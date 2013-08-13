class String
  def underscore
    strip.downcase.scan(/\w+/).join("_")
  end

  def escape
    URI.escape(self, /[<>\|:\*\"\?\\]/)
  end

  def camelize
    strip.scan(/[\da-zA-Z]+/).collect(&:capitalize).join("")
  end
end

module Dtm
  class Dtm
    def self.instance(data_store)
      wttcl = 'C:\\Program Files\\Microsoft Driver Test Manager\\Studio\\wttcl.exe'
      return Dtm.new(wttcl, data_store) if File.exist?(wttcl)

      wttcl = 'C:\\Program Files (x86)\\Microsoft Driver Test Manager\\Studio\\wttcl.exe'
      return Dtm.new(wttcl, data_store) if File.exist?(wttcl)

      raise
    end

    def initialize(wttcl, data_store)
      @wttcl = wttcl
      @data_store = data_store
    end

    def job(job_id)
      Job.new(self, job_id)
    end

    def schedule(schedule_id)
      Schedule.new(self, schedule_id)
    end

    def machines(machine_pool)
      self.set_machine_status(:machine_pool => machine_pool) do |stdout|
        stdout.split("\n").collect {|line| line.scan(/\[\w+\]/) if line.match(/Machine \[\w+\] \(ID \d+\) is in \[\w+\] state./)}.compact
      end
    end

    def availabe_machines(params)
      self.method_missing(:setmachinestatus, params) do |stdout|
        stdout.split("\n").collect{|line| line.scan(/\[\w+\]/) if line.match(/Machine \[\w+\] \(ID \d+\) is in \[\w+\] state./)}.compact
      end
    end

    def method_missing(sym, params)
      params[:data_store] = @data_store

      cmd = "\"#{@wttcl}\" #{sym.to_s.camelize} #{self.class.parameterize(params)}"
      puts cmd

      #FIXME how to deal w/ ERROR: message or the command doesn't return 0
      IO.popen(cmd) do |pipe|
        stdout = pipe.read
        block_given? ? yield(stdout) : stdout
      end
    end

    def add_job(params)
      params[:type] ||= "Automated"

      self.method_missing(:add_job, params) do |stdout|
        return self.job(stdout.slice(/\d+/)) if stdout.match(/Job Created Successfully with ID=\d+/)
        raise
      end
    end

    #FIXME design choice, put stdout processing here or leave it to job?
    def schedule_job(params)
      self.method_missing(:schedule_job, params) do |stdout|
        stdout.split("\n").select {|line| line.match(/Schedule Created with Id \d+/)}
                          .collect {|line| line.slice(/\d+/)}
                          .collect {|schedule_id| self.schedule(schedule_id)}
      end
    end

    class << self
      def parameterize(params)
        unless params.instance_of?(Hash)
          params.to_s
        else
          params = params.collect do |key, value|
            unless value.instance_of?(Array)
              "/#{key.to_s.camelize}:#{parameterize(value)}"
            else
              value.collect {|item| "/#{key.to_s.camelize} { #{parameterize(item)} }"}.join(" ")
            end
          end

          params.join(" ")
        end
      end
    end
  end
end