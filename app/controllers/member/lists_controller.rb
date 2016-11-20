class Member::ListsController < Member::BaseController

  before_filter :redirect_if_locked, only: [:lock_and_assign, :santas, :edit, :update]

  # So PayPal can post to this action
  skip_before_action :verify_authenticity_token, only: :list_payment
  skip_before_action :authenticate_user!, only: :list_payment
  skip_authorization_check only: :list_payment

  def new
    @list = current_user.lists.build
    authorize!(:new, @list)
  end

  def create
    @list = current_user.lists.build(name: params[:list][:name])
    authorize!(:create, @list)
    @list.update_attributes(list_params)

    if !@list.valid?
      flash.now[:danger] = "List could not be created. Please address the errors below."
      render :new
    else
      respond_with(@list, location: member_list_santas_path(@list))
    end
  end

  def lock_and_assign
    find_list
    authorize!(:update, @list)
    if @list.santas.count >= 3
      List::ShuffleAndAssignSantas.new(@list).assign_and_email
      flash.now[:success] = 'Recipients set and Santas notified'
    else
      flash.now[:danger] = 'You must have at least three Santas in the list first!'
    end
    render :show
  end

  def copy_list
    find_list
    authorize!(:copy, @list)
    if @list.is_locked? || Time.now > @list.gift_day
      new_list = @list.deep_clone include: :santas
      new_list.update_attributes(gift_day: Time.now + 2.months, is_locked: false, limited: true)
      @list = new_list
      respond_with(@list, location: edit_member_list_path(@list))
    else
      flash[:warning] = "List is not locked, please edit it instead!"
      render :show
    end
  end

  def edit
    find_list
    authorize!(:edit, @list)
  end

  def santas
    find_list
    authorize!(:edit, @list)
  end

  def update
    find_list
    authorize!(:update, @list)
    # This prevents the list from being updated with nothing preventing an exception.
    @list.update_attributes(list_params) if params.include?(:list)

    if !@list.valid? && params[:list].include?(:santas_attributes)
      flash.now[:danger] = "Santas could not be saved! Please try again."
      render :santas
    else
      respond_with(@list, location: member_dashboard_index_path)
    end
  end

  def destroy
    find_list
    authorize!(:destroy, @list)
    @list.destroy

    respond_with(@list, location: member_dashboard_index_path, success: "List was successfully deleted.")
  end

  def show
    find_list
    authorize!(:show, @list)
  end

  def list_payment
    response = validate_IPN_notification(request.raw_post)
    @new_payment = params
    @list = List.find(@new_payment["list_id"])
    case response
    when "VERIFIED"
      # Check the payment is complete, that the transaction hasn't already been saved,
      # that the payment receiver's email is correct, that the value is $3.00, in AUD
      if @new_payment["payment_status"] == "Complete" &&
      ProcessedTransaction.find_by(transaction_id: @new_payment["txn_id"]) == nil &&
      @new_payment["receiver_email"] == "accounts@secretsanta.website" &&
      @new_payment["mc_gross"] == "3.00" && @new_payment["mc_currency"] == "AUD"

        # If all the above is true, then we create a new transaction
        ProcessedTransaction.create!(
          transaction_id: @new_payment["txn_id"],
          list_id: @new_payment["item_number"]
        )
        @list.update_attributes(limited: false)
      else
        TransactionErrorMailer.notify_new_error(@new_payment, response).deliver_later
        flash[:warning] = "Something unexpected happened processing your payment."
        redirect_to member_list_santas_path(@list)
      end
    when "INVALID"
      TransactionErrorMailer.notify_new_error(@new_payment, response).deliver_later
      flash[:warning] = "PayPal sent back an invalid status for the transaction, please check your statement and try again."
      redirect_to member_dashboard_index_path
    else
      TransactionErrorMailer.notify_new_error(@new_payment, response).deliver_later
      flash[:danger] = "There was a problem processing your payment."
      redirect_to member_dashboard_index_path
    end
  end

protected

  def validate_IPN_notification(raw)
    uri = URI.parse("https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_notify-validate")
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.use_ssl = true
    response = http.post(uri.request_uri, raw,
                         "Content-Length" => "#{raw.size}"
                       ).body
  end

private

  def list_params
    params.require(:list)
          .permit(:name,
                  :gift_day,
                  :gift_value,
                  santas_attributes: [:id, :name, :email, :_destroy]
                 )
  end

  def find_list
    if params.include?("list_id")
      @list = List.find(params[:list_id])
    else
      @list = List.find(params[:id])
    end
  end

  def redirect_if_locked
    find_list
    if @list.is_locked?
      flash[:warning] = "Sorry! You can no longer modify this list!
                        The list has been locked and Santas notified."
      redirect_to member_dashboard_index_path
    end
  end

end
