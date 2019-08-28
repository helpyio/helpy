require 'active_record/connection_adapters/postgresql/schema_statements'

#
# Monkey-patch the refused Rails 4.2 patch at https://github.com/rails/rails/pull/31330
#
# Updates sequence logic to support PostgreSQL 10.
#

module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module SchemaStatements
        # Resets the sequence of a table's primary key to the maximum value.
        def reset_pk_sequence!(table, pk = nil, sequence = nil) #:nodoc:
          unless pk && sequence
            default_pk, default_sequence = pk_and_sequence_for(table)

            pk ||= default_pk
            sequence ||= default_sequence
          end

          if @logger && pk && !sequence
            @logger.warn "#{table} has primary key #{pk} with no default sequence"
          end

          if pk && sequence
            quoted_sequence = quote_table_name(sequence)
            max_pk = select_value("SELECT MAX(#{quote_column_name pk}) FROM #{quote_table_name(table)}")
            if max_pk.nil?
              if postgresql_version >= 100000
                minvalue = select_value("SELECT seqmin FROM pg_sequence WHERE seqrelid = #{quote(quoted_sequence)}::regclass")
              else
                minvalue = select_value("SELECT min_value FROM #{quoted_sequence}")
              end
            end

            select_value <<-end_sql, 'SCHEMA'
              SELECT setval(#{quote(quoted_sequence)}, #{max_pk ? max_pk : minvalue}, #{max_pk ? true : false})
            end_sql
          end
        end
      end
    end
  end
end

