namespace :hh do
  desc "Get latest vacancies and classify them"
  task :pull_latest => :environment do
    logger = Logger.new(STDOUT)

    logger.info "Rake is pulling latest vacancies..."		
		Vacancy.parse_latest(logger)
		logger.info "Pulling is completed"
		
		logger.info "Rake classify vacancies..."
		Vacancy.classify_all(logger)
		logger.info "Classification completed"
  end

  task :expire_stat_pages => :environment do
    Vacancy.expire_stat_pages
  end
end