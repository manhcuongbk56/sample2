module ActiveRecordScope
  def self.included(base)
    base.scope :not_deleted, -> { base.where(deleted: false) }
    base.send(:default_scope) { base.not_deleted }
    base.scope :only_deleted, -> { base.unscope(where: :deleted).where(deleted: true) }

    def delete
      update deleted: true
    end

    def recover
      update deleted: false
    end
  end
end
