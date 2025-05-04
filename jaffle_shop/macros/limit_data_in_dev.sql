{% macro limit_data_in_dev(column_name, day_limit=3) %}
{% if target.name == 'dev' %}
where {{ column_name }} >= dateadd(day, -{{ day_limit }}, current_timestamp)
{% endif %}
{% endmacro %}