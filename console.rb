require_relative( 'models/customer' )
require_relative( 'models/ticket' )
require_relative( 'models/film' )
require('pry-byebug')

Film.delete_all()
Ticket.delete_all()
Customer.delete_all()

customer1 = Customer.new({ 'name' => 'Frazzoo' })
customer1.save()
customer2 = Customer.new({ 'name' => 'big L' })
customer2.save()
customer3 = Customer.new({ 'name' => 'ED' })
customer3.save()

film1 = Film.new({'title' => 'Black Panther', 'price' => '20'})
film1.save()
film2 = Film.new({'title' => 'Iron Man 3', 'price' => '10' })
film2.save()

ticket1 = Ticket.new( 'customer_id' => customer1.id, 'film_id' => film1.id })
ticket1.save()
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id })
ticket2.save()
ticket3 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film2.id})
ticket3.save()
ticket4 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film2.id})
ticket4.save()

binding.pry
nil
