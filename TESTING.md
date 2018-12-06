# TESTING

Create a branch for this cookbook. Create a PR. This will trigger a build on Travis CI. Make sure it succeeds.
You can also use test kitchen with AWS. Make sure you modify it with your custom parameters like Security Group id and
others.

```
KITCHEN_YAML=.kitchen.aws.yml kitchen verify default
```