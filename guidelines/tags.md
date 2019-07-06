# Tags

- All cloud resources, for which it is possible to apply tags, MUST have a
  "name", "environment", and "project" tag.
  - For AWS resources, we MUST also include a "Name" tag, as it is useful for
    working with the UI.
- The "environment" tag MUST be either "development", "staging", or
  "production".
  - The "name" MAY include an indicator of environment, but it is not necessary.
    The tag is the source of truth.
- Tags SHOULD use full names (i.e. "development" instead of "dev").
