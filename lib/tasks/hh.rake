namespace :hh do
  desc "Get latest vacancies and classify them"
  task :pull_latest => :environment do
    logger = Logger.new(STDOUT)

    logger.info "Rake is pulling latest vacancies..."		
		Vacancy.parse_latest(logger)
		logger.info "Pulling is completed"
		
		logger.info "Rake classify vacancies..."
		logger.info "Classification completed"
  end
end