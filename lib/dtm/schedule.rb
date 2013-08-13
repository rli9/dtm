module Dtm
  class Schedule
    def self.wait_for_completed(schedules, wait_interval)
      while !schedules.empty? do
        completed_schedules = schedules.select(&:completed?)

        unless completed_schedules.empty?
          schedules = schedules - completed_schedules
          puts "Remain #{schedules.length}: #{schedules.collect(&:id).join(', ')}"
        end

        sleep(wait_interval) unless schedules.empty?
      end
    end

    attr_reader :id

    def initialize(dtm, schedule_id)
      @dtm = dtm
      @id = schedule_id
    end

    def completed?
      @dtm.schedule_status(:schedule_id => @id) {|stdout| stdout.match(/Schedule Status : Completed/)}
    end
  end
end