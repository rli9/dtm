module Dtm
  class ExecuteTaskDesc
    class << self
      def desc(params)
        ExecuteTaskDesc.new(params).desc
      end
    end

    def initialize(params)
      params[:type] = "Execute"
      params[:execution_phase] ||= "Regular"
      params[:failure_action] ||= "FailAndStop"
      #FIXME should we do this for user?
      params[:command_line] = "\"#{params[:command_line]}\""

      @params = params
    end

    def desc
      @params
    end
  end
end
