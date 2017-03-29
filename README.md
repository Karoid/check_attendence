# CheckAttendence
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'check_attendence'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install check_attendence
```


then make database for check_attendence!
```bash
$ rails g check_attendence MODEL
```
this will make migration file for the game points
```bash
$ rake db:migrate
```
then you can do your game in route "/attendence/check"
## Contributing
Contribution directions go here.

## What to do
* **solved** / error should not orrur when user record destroyed
* **solved** / make manual attendence check system
* **solved** / should do admin authourization
* make whitelist group who should be checked
* **solved** / make download button to download list who where present in schedule page
* make download button to download list who where present in schedule list page
## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
