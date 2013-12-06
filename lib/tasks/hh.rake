namespace :hh do
  desc "Get latest vacancies and classify them"
  task :pull_latest => :environment do
    Rails.logger.info "Rake is pulling latest vacancies..."
		Vacancy.parse_latest
		Rails.logger.info "Pulling is completed"
		
		Rails.logger.info "Rake classify vacancies..."
		Rails.logger.info "Classification completed"
  end
end