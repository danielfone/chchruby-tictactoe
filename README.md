
1. Install gems (just rspec and benchmark-ips)

  ```
      $ bundle install
  ```
2. Run the test suite, it should fail with loads of `NotImplementedError`s

  ```
    $ rspec -cfd  # --color --format documentation
  ```
3. Fix the specs (probably in order)

4. Once you've got your board working, edit the add it to the performance test in tictactoe_speed.rb and see how it compares!

  ```
    $ ruby tictactoe_speed.rb
    Testing FastBoard...
    Testing SlowBoard...
    ==> Benchmarking playthrough
    Calculating -------------------------------------
        Fast Playthrough     3.025k i/100ms
        Slow Playthrough   147.000  i/100ms
    -------------------------------------------------
        Fast Playthrough     31.701k (± 1.8%) i/s -     33.275k in   1.049992s
        Slow Playthrough      1.482k (± 3.7%) i/s -      1.617k in   1.092703s

    Comparison:
        Fast Playthrough:    31700.5 i/s
        Slow Playthrough:     1482.0 i/s - 21.39x slower
  ```
