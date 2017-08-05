{% from "sudoers/map.jinja" import sudoers with context %}

sudo:
  pkg.installed:
    - name: {{ sudoers.pkg }}

{{ sudoers.get('config-path', '/etc') }}/sudoers:
  file.managed:
    - user: root
    - group: {{ sudoers.get('group', 'root') }}
    - mode: 440
    - template: jinja
    - source: salt://sudoers/files/sudoers
# https://github.com/saltstack/salt/issues/42404 means this check won't
# work.  This is fixed with 2017.7.1, so once that version releases we can
# uncomment this.
#    - check_cmd: {{ sudoers.get('exec-prefix', '/usr/sbin') }}/visudo -c -f
    - context:
        included: False
    - require:
      - pkg: sudo
