module Schema
  SCHEMAS = {
    'company' => {
      'type' => 'object',
      'required' => ['id','name','top_up','email_status'],
      'properties' => {
        'id' => { 'type' => 'integer' },
        'name' => { 'type' => 'string' },
        'top_up' => { 'type' => 'integer' },
        'email_status' => { 'type' => 'boolean' }
      }
    },
    'user' => {
      'type' => 'object',
      'required' => ['first_name','last_name','email','company_id','email_status','active_status','tokens'],
      'properties' => {
        'first_name' => { 'type' => 'string' },
        'last_name' => { 'type' => 'string' },
        'email' => { 'type' => 'string' },
        'company_id' => { 'type' => 'integer' },
        'email_status' => { 'type' => 'boolean' },
        'active_status' => { 'type' => 'boolean' },
        'tokens' => { 'type' => 'integer' }
      }
    }
  }
end