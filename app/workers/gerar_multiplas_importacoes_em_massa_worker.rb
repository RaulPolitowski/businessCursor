class GerarMultiplasImportacoesEmMassaWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: false

  def perform(qtd)
    ss = Sidekiq::ScheduledSet.new
    ps = Sidekiq::ProcessSet.new

    datetime_started = DateTime.now
    puts "DataHora Inicio GerarMultiplasImportacaoEmMassa #{datetime_started}"

    datetime_stop = DateTime.parse(datetime_started.next_day.strftime("%Y-%m-%dT05:00:00%z"))
    puts "DataHora Final GerarMultiplasImportacaoEmMassa #{datetime_stop}"

    begin
      Importacao.importacao_em_massa(qtd) if have_imports_jobs?
      sleep 300
    end while DateTime.now < datetime_stop
  end

  def have_imports_jobs?
    queue = Sidekiq::Queue.new
    workerSidekiq = Sidekiq::Workers.new
    workerSidekiq.each { | _process_id, _thread_id, work | puts work['payload']['class'] == 'ImporterCnpjWorker' }

    current_jobs = workerSidekiq.select { |_process_id, _thread_id, work| work['payload']['class'] == 'ImporterCnpjWorker' }
    queue_jobs = queue.select { |job| job.klass == 'ImporterCnpjWorker' }

    puts "CurrentJobs: #{current_jobs.size}"
    puts "QueueJobs: #{queue_jobs.size}"

    (current_jobs.empty? && queue_jobs.empty?) && queue.size <= 10000
  end
end

