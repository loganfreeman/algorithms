class String

  def rot13
    self.tr("A-Ma-mN-Zn-z","N-Zn-zA-Ma-m")
  end

end

def rot13(secret_messages)
  # your code here
    secret_messages.map { |s| s.rot13  }
end
