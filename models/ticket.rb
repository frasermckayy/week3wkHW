require_relative("../db/sql_runner")


class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @customer_id = options["customer_id"].to_i
    @film_id = options["film_id"].to_i
  end

  #CRUD
  def save()
    sql = "INSERT INTO tickets (customer_id, film_id) VALUES ($1, $2) RETURNING id;"
    values = [@customer_id, @film_id]
    ticket = SqlRunner.run(sql, values).first()
    @id = ticket["id"].to_i
  end

  def self.all()
    sql = "SELECT * FROM tickets;"
    tickets = SqlRunner.run(sql)
    result = Ticket.map_tickets(tickets)
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM tickets;"
    SqlRunner.run(sql)
  end

#mapping
  def self.map_tickets(ticket_data)
    return ticket_data.map{|ticket_hash| Ticket.new(ticket_hash)}
  end
end
