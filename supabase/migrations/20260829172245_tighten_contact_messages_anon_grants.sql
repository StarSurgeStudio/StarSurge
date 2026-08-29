/*
# Tighten contact_messages column privileges for anon

The RLS policies on contact_messages already restrict SELECT/UPDATE/DELETE
to authenticated users only, while allowing anon to INSERT. However, the
default table grants gave anon all four privileges at the column level.

This migration revokes SELECT, UPDATE, and DELETE from the anon role on
contact_messages so the privilege grants match the policy intent. RLS is
the real enforcement layer, but tightening grants follows least-privilege.

1. Security changes
- REVOKE SELECT, UPDATE, DELETE on contact_messages FROM anon.
- GRANT INSERT on contact_messages TO anon (explicit, for the contact form).
*/

REVOKE ALL ON contact_messages FROM anon;
GRANT INSERT ON contact_messages TO anon;
