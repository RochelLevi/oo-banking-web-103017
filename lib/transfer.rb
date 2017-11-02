class Transfer
  @@completed_transactions = []

  attr_accessor :sender, :receiver, :status, :amount

  def initialize(sender, receiver, amount)
    @sender = sender
    @receiver = receiver
    @status = "pending"
    @amount = amount
  end

  def valid?
    @sender.valid? && @receiver.valid? && @amount < @sender.balance
  end

  def execute_transaction
    if valid? && @status != "complete"
      @receiver.deposit(@amount)
      @sender.withdraw(@amount)
      @status = "complete"
      @@completed_transactions << self
    elsif !valid?
      @status = "rejected"
      "Transaction rejected. Please check your account balance."
    end
  end

  def reverse_transfer
    if @status == "complete"
      @receiver.withdraw(@amount)
      @sender.deposit(@amount)
      @status = "reversed"
      @@completed_transactions.pop
    end 
  end
end
