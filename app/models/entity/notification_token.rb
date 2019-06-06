module Entity
  class NotificationToken < Base
    expose :id, documentation: { type: "Integer" }
    expose :user_id, documentation: { type: "Integer", desc: "The User ID currently assigned to the token." }
    expose :device_token, documentation: { type: "String", desc: "The unique identifier for the device." }
    expose :device_description, documentation: { type: String, desc: "The description for the Device." }
    expose :enabled, documentation: { type: "Boolean", desc: "If notifications for the device are enable." }
  end
end
