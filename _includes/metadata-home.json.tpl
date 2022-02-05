{
    "page": {
        "title": "Introduction",
        "level": "1.1",
        "depth": 1,

        {% if site.posts %}
        "next": {
            "title": "{{site.posts.first.title}}",
            "level": "1.2",
            "depth": 1,
            "path": "{{site.posts.first.path}}",
            "ref": "{{site.posts.first.path}}",
            "articles": []
        },
        {% endif %}
        "dir": "ltr"
    },

    {%- include metadata.json.tpl -%}
}