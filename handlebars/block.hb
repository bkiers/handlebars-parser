{{#with person}}
  {{firstname}} {{lastname}}
{{/with}}

{{#each persons}}
  {{>person person=.}}
{{/each}}

{{#someHelper true}}
  <div>Some known helper</div>
  {{#anotherHelper true}}
  <div>Another known helper</div>
  {{/anotherHelper}}
{{/someHelper}}