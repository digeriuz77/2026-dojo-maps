'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useAuth } from '../lib/AuthContext';

export default function ForgotPasswordPage() {
  const { resetPassword } = useAuth();
  const [email, setEmail] = useState('');
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    setMessage('');
    setLoading(true);

    try {
      await resetPassword(email);
      setMessage('If an account exists, you will receive a password reset email.');
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Failed to send reset email';
      setError(msg);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="page-container flex items-center justify-center min-h-screen p-4">
      <div className="form-card">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-maps-navy mb-2">Reset Password</h1>
          <p className="text-gray-600">Enter your email to receive a reset link</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          {error && <div className="error bg-red-50 p-3 rounded-lg">{error}</div>}
          {message && <div className="bg-green-50 text-green-700 p-3 rounded-lg">{message}</div>}

          <div>
            <label htmlFor="email" className="label">Email</label>
            <input
              id="email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="input"
              placeholder="you@example.com"
              required
            />
          </div>

          <button type="submit" className="btn-primary w-full" disabled={loading}>
            {loading ? 'Sending...' : 'Send Reset Link'}
          </button>
        </form>

        <div className="mt-6 text-center">
          <p className="text-gray-600">
            Remember your password?{' '}
            <Link href="/login" className="text-maps-teal font-medium hover:underline">
              Sign in
            </Link>
          </p>
        </div>

        <div className="mt-8 pt-6 border-t border-gray-200 text-center">
          <Link href="/" className="text-maps-navy hover:underline">
            ← Back to home
          </Link>
        </div>
      </div>
    </div>
  );
}
