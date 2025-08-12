require_dependency Rails.root.join("lib", "document_parser").to_s

module DocumentParser
  def dni?(document_type)
    dni_type = class.name == "RemoteCensusApi" ? "D" : "1"
    document_type.to_s == dni_type
  end
end
