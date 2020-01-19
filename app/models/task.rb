class Task < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  before_validation :set_nameless_name
  validates :name, presence: true
  validates :name, length: {maximum: 30}
  validate :validate_name_not_including_comma

  scope :recent, -> {order(created_at: :desc)}

  # kaminari_config.rb よりも優先される
  paginates_per 10

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

  def set_nameless_name
    self.name = '名前なし' if name.blank?
  end

  # [ransack] search処理に使用するカラムを指定（指定以外は無視）
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  # [ransack] search処理の関連カラムを指定
  def self.ransackable_association(auth_object = nil)
    []
  end

  # CSVデータの出力順序
  def self.csv_attributes
    ["name", 'description', "created_at", "updated_at"]
  end

  # 現在の全てのtaskデータをCSVデータとして返却する
  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{ |attr| task.send(attr) }
      end
    end
  end

  # CSVファイルからtaskオブジェクトを生成
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = new
      # to_hashにより {"name"=>xxx, "description"=>xxx ...} といったデータに変換される
      # slice(*csv_attributes) は slice("name", "description" ...)と同じ
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end
end
