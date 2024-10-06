# == Schema Information
#
# Table name: follow_requests
#
#  id           :bigint           not null, primary key
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer
#  sender_id    :integer
#

class FollowRequest < ApplicationRecord
  validates(:sender, { :presence => true})
  validates(:recipient, { :presence => true })
  validates(:recipient_id, {
    :uniqueness => { :scope => [:sender_id] }
  })

  # Association accessor methods to define:
  
  ## Direct associations
  belongs_to(:user)

  # Association accessor methods to define:

  # FollowRequest#sender_id: returns the id of the user who sent this follow request

  belongs_to(:sender, class_name: "User", foreign_key: "sender_id")

  # FollowRequest#sender: returns a row from the users table associated to this follow request by the sender_id column
  belongs_to(:sender, class_name: "User", foreign_key: "sender_id")

  # FollowRequest#recipient: returns a row from the users table associated to this follow request by the recipient_id column

  belongs_to(:recipient, foreign_key: "recipient_id" )

  def sender
    my_sender_id = self.sender_id

    matching_users = User.where({ :id => my_sender_id })

    the_user = matching_users.at(0)

    return the_user
  end

  def recipient
    my_recipient_id = self.recipient_id

    matching_users = User.where({ :id => my_recipient_id })

    the_user = matching_users.at(0)

    return the_user
  end
end
