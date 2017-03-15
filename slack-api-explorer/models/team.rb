class Team
  field :api, type: Boolean, default: false
  scope :api, -> { where(api: true) }
end
