require_dependency Rails.root.join("lib", "census_api").to_s

class CensusApi
  attr_accessor :req_document_type

  def initialize
    @auth_token = nil
    @base_url = Rails.application.secrets.census_api_end_point
    @login_url = "#{@base_url}/api/auth/login"
    @habitante_url = "#{@base_url}/padron/api/habitante/GetPorDocumento"
  end

  def call(document_type, document_number)
    response = nil
    get_document_number_variants(document_type, document_number).detect do |variant|
      response = Response.new(get_response_body(document_type, variant), document_type)
      return response if response.valid?
    end
    response.valid? ? response : Response.new(invalid_response, document_type)
  end

  class Response
    def initialize(body, req_document_type)
      @body = body
      @req_document_type = req_document_type
    end

    def valid?
      return false if citizen_not_found || !correct_document_type

      data[:fechabaja].blank?
    end

    def date_of_birth
      str = data[:fechanacim]
      year, month, day = str.match(/(\d\d\d?\d?)\D(\d\d?)\D(\d\d?)/)[1..3]
      return nil unless day.present? && month.present? && year.present?

      Time.zone.local(year.to_i, month.to_i, day.to_i).to_date
    end

    def district_code
      str = data[:domicilio]
      str.match(/Dist:\s*(\d+)/)[1]
    end

    def gender
      case data[:sexo]
      when "1"
        "male"
      when "6"
        "female"
      end
    end

    private

      def data
        @body[:habitante]
      end

      def correct_document_type
        data[:tipodocu] == @req_document_type ||
          (data[:tipodocu] == "3" && @req_document_type == "4")
      end

      def citizen_not_found
        data[:tiene_errores] ||
          data[:mensaje_original] == 'No existe el habitante especificado en el padrón'
      end
  end

  private

    def login
      return @auth_token if @auth_token.present?

      payload = {
        email: Rails.application.secrets.census_api_user_email,
        password: Rails.application.secrets.census_api_password,
        idacceso: Rails.application.secrets.census_api_idacceso
      }

      uri = URI(@login_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"

      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request.body = payload.to_json

      response = http.request(request)
      if response.code == "200" && JSON.parse(response.body)["success"]
        @auth_token = JSON.parse(response.body)["accesstoken"]["token"]
      else
        raise "Error en la autenticación con el servicio del padrón"
      end
    end

    def get_response_body(document_type, document_number)
      return stubbed_response(document_type, document_number) unless end_point_available?

      token = login
      uri = URI("#{@habitante_url}/#{document_number}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"

      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{token}"
      request["Accept"] = "*/*"

      response = http.request(request)
      if response.code == "200"
        JSON.parse(response.body, symbolize_names: true)
      else
        Response.new(invalid_response, document_type)
      end
    end

    def end_point_defined?
      Rails.application.secrets.census_api_end_point.present? &&
      Rails.application.secrets.census_api_user_email.present? &&
      Rails.application.secrets.census_api_password.present? &&
      Rails.application.secrets.census_api_idacceso.present?
    end

    def end_point_available?
      (Rails.env.staging? || Rails.env.preproduction? || Rails.env.production?) && end_point_defined?
    end

    def stubbed_invalid_response
      Response.new(invalid_response, @req_document_type)
    end

    def stubbed_valid_response
      {
        habitante: {
          nombre: "GALA",
          apellido1: "VAZQUEZ",
          apellido2: "CARRILERO",
          sexo: "6",
          fechanacim: "2005-07-08T00:00:00",
          edad: 20,
          tipodocu: "1",
          dni: "12345678",
          nif: "Z",
          lextr: "",
          pasaporte: "",
          fechacaducidad: "2030-01-17T00:00:00",
          caducado: false,
          fechaalta: "2005-07-08T00:00:00",
          motivoalta: "1",
          fechabaja: nil,
          motivobaja: "",
          fecha_empadron: "2005-07-08T00:00:00",
          fecha_renovacion: nil,
          nombrecompleto: "GALA VAZQUEZ CARRILERO",
          domicilio: "Dist: 01 Secc: 004 CALLE GENERAL WEYLER     2 , Piso: P01, Pta: 0003",
          bfechabaja: false,
          tiene_errores: false,
          mensaje_original: 'Ok'
        },
        lastmovimiento: {},
        vivienda: {},
        domicilio: {},
        paisNacim: {},
        consulado: {},
        estudio: {},
        habitantes_unidad: {},
        familias: {},
        alertas: 0,
        alertas_no_leidas: 0,
        fvar: "",
        enlazarterceros: false
      }
    end

    def invalid_response
      {
        habitante: {
          nombre: nil,
          apellido1: nil,
          apellido2: nil,
          sexo: nil,
          fechanacim: nil,
          edad: nil,
          tipodocu: nil,
          dni: nil,
          nif: nil,
          lextr: nil,
          pasaporte: nil,
          fechacaducidad: nil,
          caducado: false,
          fechaalta: nil,
          motivoalta: nil,
          fechabaja: nil,
          motivobaja: nil,
          fecha_empadron: nil,
          fecha_renovacion: nil,
          nombrecompleto: nil,
          domicilio: nil,
          bfechabaja: false,
          tiene_errores: true,
          mensaje_original: 'No existe el habitante especificado en el padrón'
        },
        lastmovimiento: {},
        vivienda: {},
        domicilio: {},
        paisNacim: {},
        consulado: {},
        estudio: {},
        habitantes_unidad: {},
        familias: {},
        alertas: 0,
        alertas_no_leidas: 0,
        fvar: "",
        enlazarterceros: false
      }
    end
end
