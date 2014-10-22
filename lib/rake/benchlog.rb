require 'rake'
require 'logger'
require 'benchmark'

module Rake
  module Benchlog
    class BenchFormatter < Logger::Formatter
      def call(severity, timestamp, progname, msg)
        hash = {
          pid: $$,
          timestamp: timestamp.strftime("%F %T %Z"),
          task_name: msg[:task_name],
          status: msg[:status]
        }
        msg.delete :task_name
        msg.delete :status
        msg.each { |k, v| hash[k] = "%.5f" % v }
        hash.map { |k, v| "#{k}:#{v}" }.join("\t") + "\n"
      end
    end

    class << self
      def logger=(logger)
        logger.formatter = formatter
        @logger = logger
      end

      def log(name, status, bench=nil)
        hash = { task_name: name, status: status }
        hash.merge!({ utime: bench.utime, stime: bench.stime, total: bench.total, real: bench.real }) unless bench.nil?
        logger.info(hash)
      end

      private

      def logger
        @logger ||= Logger.new(STDOUT).tap do |logger|
          logger.formatter = formatter
        end
        @logger
      end

      def formatter
        @formatter = BenchFormatter.new
      end
    end
  end
end

class Rake::Task
  def execute_with_benchmark_and_logging(*args)
    status = :success
    e = nil
    bench = Benchmark.measure do
      begin
        execute_without_benchmark_and_logging(*args)
      rescue => e
        status = :fail
      end
    end
    Rake::Benchlog.log name, status, bench
    raise e if e
  end

  alias_method :execute_without_benchmark_and_logging, :execute
  alias_method :execute, :execute_with_benchmark_and_logging
end
