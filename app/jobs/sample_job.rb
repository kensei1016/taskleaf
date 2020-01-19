class SampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Sidekiq::Logging.logger.info "サンプルジョブを実行しました。"
    p "#{Time.now} :SampleJobが実行されました〜"
  end
end
