<!-- usage documentation: https://expeditor.chef.io/docs/reference/changelog/#common-changelog -->
<!-- latest_release 2.0.11 -->
## [v2.0.11](https://github.com/chef/chef-cli/tree/v2.0.11) (2020-05-12)

#### Merged Pull Requests
- Update test configs to better cache gems + test on Ruby 2.7 [#67](https://github.com/chef/chef-cli/pull/67) ([tas50](https://github.com/tas50))
<!-- latest_release -->

<!-- release_rollup since=2.0.10 -->
### Changes not yet released to rubygems.org

#### Merged Pull Requests
- Update test configs to better cache gems + test on Ruby 2.7 [#67](https://github.com/chef/chef-cli/pull/67) ([tas50](https://github.com/tas50)) <!-- 2.0.11 -->
<!-- release_rollup -->

<!-- latest_stable_release -->
## [v2.0.10](https://github.com/chef/chef-cli/tree/v2.0.10) (2020-05-05)

#### Merged Pull Requests
- Additional distribution constants [#45](https://github.com/chef/chef-cli/pull/45) ([ramereth](https://github.com/ramereth))
- Remove the instance_eval from the gemfile [#49](https://github.com/chef/chef-cli/pull/49) ([tas50](https://github.com/tas50))
- Update addressable requirement from &gt;= 2.3.5, &lt; 2.6 to &gt;= 2.3.5, &lt; 2.8 [#51](https://github.com/chef/chef-cli/pull/51) ([dependabot-preview[bot]](https://github.com/dependabot-preview[bot]))
- Update paint requirement from ~&gt; 1.0 to &gt;= 1, &lt; 3 [#52](https://github.com/chef/chef-cli/pull/52) ([dependabot-preview[bot]](https://github.com/dependabot-preview[bot]))
- new include_policies not added to lock on &#39;chef update&#39; [#38](https://github.com/chef/chef-cli/pull/38) ([tyler-ball](https://github.com/tyler-ball))
- Replace usage of deprecated Net::HTTPServerException error class [#53](https://github.com/chef/chef-cli/pull/53) ([tyler-ball](https://github.com/tyler-ball))
- Improve how we test the gem / add Ruby 2.7 testing [#57](https://github.com/chef/chef-cli/pull/57) ([tas50](https://github.com/tas50))
- Fix typos in the readmes and update examples [#59](https://github.com/chef/chef-cli/pull/59) ([tas50](https://github.com/tas50))
- Add logging to export command [#56](https://github.com/chef/chef-cli/pull/56) ([mbaitelman](https://github.com/mbaitelman))
- recognize .yml as a valid recipe extension [#63](https://github.com/chef/chef-cli/pull/63) ([ChefRycar](https://github.com/ChefRycar))
<!-- latest_stable_release -->

## [v2.0.0](https://github.com/chef/chef-cli/tree/v2.0.0) (2019-10-02)

#### Merged Pull Requests
- Rename `chef` binary to `chef-cli` [#35](https://github.com/chef/chef-cli/pull/35) ([afiune](https://github.com/afiune))

## [v1.0.16](https://github.com/chef/chef-cli/tree/v1.0.16) (2019-09-17)

#### Merged Pull Requests
- Don&#39;t generate cookbooks with long_description metadata [#28](https://github.com/chef/chef-cli/pull/28) ([tas50](https://github.com/tas50))
- Remove foodcritic from the delivery local config in the generator [#33](https://github.com/chef/chef-cli/pull/33) ([tas50](https://github.com/tas50))

## [v1.0.14](https://github.com/chef/chef-cli/tree/v1.0.14) (2019-09-16)

#### Merged Pull Requests
- Remove `chef verify` hidden internal command. [#30](https://github.com/chef/chef-cli/pull/30) ([marcparadise](https://github.com/marcparadise))

## [v1.0.13](https://github.com/chef/chef-cli/tree/v1.0.13) (2019-09-04)

#### Merged Pull Requests
- Shellout libraries expect cwd to be provided as a string [#26](https://github.com/chef/chef-cli/pull/26) ([tyler-ball](https://github.com/tyler-ball))
- Display correct version of tools + speed up [#27](https://github.com/chef/chef-cli/pull/27) ([afiune](https://github.com/afiune))

## [v1.0.11](https://github.com/chef/chef-cli/tree/v1.0.11) (2019-07-25)

#### Merged Pull Requests
- Fix failure in chef generate file command [#11](https://github.com/chef/chef-cli/pull/11) ([tas50](https://github.com/tas50))
- Add missing require for &#39;chef-cli/cli&#39; in spec_helper [#23](https://github.com/chef/chef-cli/pull/23) ([marcparadise](https://github.com/marcparadise))

## [v1.0.9](https://github.com/chef/chef-cli/tree/v1.0.9) (2019-07-20)

#### Merged Pull Requests
- Run specs in Buildkite on Windows [#20](https://github.com/chef/chef-cli/pull/20) ([tas50](https://github.com/tas50))
- Disable chef-run telemetry data during CI tests [#16](https://github.com/chef/chef-cli/pull/16) ([tyler-ball](https://github.com/tyler-ball))
- Remove knife-spork verification, and berks integration tests [#21](https://github.com/chef/chef-cli/pull/21) ([marcparadise](https://github.com/marcparadise))

## [v1.0.6](https://github.com/chef/chef-cli/tree/v1.0.6) (2019-07-16)

#### Merged Pull Requests
- new chefstyle rules for 0.13.2 [#14](https://github.com/chef/chef-cli/pull/14) ([lamont-granquist](https://github.com/lamont-granquist))
- Wire the provision command back up so the deprecation warning works [#15](https://github.com/chef/chef-cli/pull/15) ([tas50](https://github.com/tas50))
- Loosen the Chef dependency to allow 14.x or later [#19](https://github.com/chef/chef-cli/pull/19) ([tas50](https://github.com/tas50))

## [v1.0.3](https://github.com/chef/chef-cli/tree/v1.0.3) (2019-07-08)

#### Merged Pull Requests
- Set version to 1.0 and wipe the changelog [#4](https://github.com/chef/chef-cli/pull/4) ([tas50](https://github.com/tas50))
- Ensure omnibus-package tests are testing omnibus [#5](https://github.com/chef/chef-cli/pull/5) ([marcparadise](https://github.com/marcparadise))
- Update README.md [#6](https://github.com/chef/chef-cli/pull/6) ([marcparadise](https://github.com/marcparadise))
- Change the gem authors + remove reference to old building.md [#7](https://github.com/chef/chef-cli/pull/7) ([tas50](https://github.com/tas50))