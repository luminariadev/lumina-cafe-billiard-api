class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "orders_#{params[:branch_id]}"
  end

  def unsubscribed
    stop_all_streams
  end

  # Broadcast new order to kitchen display
  def self.broadcast_new_order(transaksi, branch_id)
    ActionCable.server.broadcast("orders_#{branch_id}", {
      type: 'new_order',
      transaksi: transaksi.as_json(include: :transaksi_items)
    })
  end

  # Broadcast status update
  def self.broadcast_status_update(transaksi, branch_id)
    ActionCable.server.broadcast("orders_#{branch_id}", {
      type: 'status_update',
      transaksi_id: transaksi.id,
      status: transaksi.status
    })
  end

  # Broadcast payment received
  def self.broadcast_payment_received(transaksi, branch_id)
    ActionCable.server.broadcast("orders_#{branch_id}", {
      type: 'payment_received',
      transaksi_id: transaksi.id,
      amount: transaksi.total_amount
    })
  end
end
