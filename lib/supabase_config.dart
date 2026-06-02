import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://gmebzrctmdnpmesiabzy.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdtZWJ6cmN0bWRucG1lc2lhYnp5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAzMTM2MTgsImV4cCI6MjA5NTg4OTYxOH0.QE70ERWDYluSmnuOw88VcweE9gw2arDpqN1-0dL10e0';

  static SupabaseClient get client => Supabase.instance.client;
}