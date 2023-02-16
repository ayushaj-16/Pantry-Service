# Service to send notification to user
class NotificationService
  def self.send(id, uid, time)
    # get employee details from Auth Service
    uri = URI("http://localhost:3001/api/v1/users/#{uid}")
    res = Net::HTTP.get(uri)
    details = JSON.parse(res)

    # setup payload for the Notification Service
    payload = {
      'employee_name' => details['name'],
      'employee_id' => uid,
      'order_id' => id,
      'chef_name' => 'PantryGuy',
      'duration' => time,
      'employee_email' => details['email']
    }
    uri = URI('http://localhost:3002/orders')
    Net::HTTP.post_form(uri, payload)
  end
end
