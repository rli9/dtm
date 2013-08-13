module Dtm
  class Job
    attr_reader :id
    def initialize(dtm, job_id)
      @dtm = dtm
      @id = job_id
    end

    def delete
      #FIXME check whether delete is successful or not
      #Delete job will also delete associated schedules
      @dtm.delete_job(:job_id => @id)
    end

    def schedule(params)
      params[:job_id] = @id
      @dtm.schedule_job(params)
    end
  end
end