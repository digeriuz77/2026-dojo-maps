'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useAuth } from '../lib/AuthContext';
import { api, UserProfile, LeaderboardEntry } from '../lib/api';

export default function DashboardPage() {
  const router = useRouter();
  const { user, signOut, loading } = useAuth();
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [leaderboard, setLeaderboard] = useState<LeaderboardEntry[]>([]);

  useEffect(() => {
    if (!loading && !user) {
      router.push('/login');
      return;
    }

    async function fetchData() {
      try {
        const [profileData, leaderboardData] = await Promise.all([
          api.progress.profile().catch(() => null),
          api.leaderboard.topUsers(5),
        ]);
        setProfile(profileData);
        setLeaderboard(leaderboardData);
      } catch {
        // Silently fail
      }
    }

    if (user) {
      fetchData();
    }
  }, [user, loading, router]);

  async function handleSignOut() {
    await signOut();
    router.push('/login');
  }

  if (loading || !user) {
    return (
      <div className="page-container min-h-screen flex items-center justify-center">
        <div className="text-white text-xl">Loading...</div>
      </div>
    );
  }

  return (
    <div className="page-container min-h-screen">
      <nav className="bg-maps-navy/90 backdrop-blur-sm p-4">
        <div className="container mx-auto flex items-center justify-between">
          <Link href="/dashboard" className="text-2xl font-bold text-white">
            MAPS MI Training
          </Link>
          <div className="flex items-center gap-6">
            <Link href="/dashboard" className="nav-link nav-link-active">Dashboard</Link>
            <Link href="/modules" className="nav-link">Modules</Link>
            <Link href="/practice" className="nav-link">Free Practice</Link>
            <div className="flex items-center gap-4">
              <span className="text-white/80">{user.display_name || user.email}</span>
              <button onClick={handleSignOut} className="btn-secondary text-sm py-2">
                Sign Out
              </button>
            </div>
          </div>
        </div>
      </nav>

      <main className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-white mb-2">
            Welcome, {user.display_name || 'Learner'}!
          </h1>
          <p className="text-white/70">Continue your MI learning journey</p>
        </div>

        <div className="grid md:grid-cols-3 gap-6 mb-8">
          <div className="card bg-gradient-to-br from-maps-teal to-maps-teal-light text-white">
            <div className="text-sm opacity-80 mb-1">Total Points</div>
            <div className="text-4xl font-bold">{profile?.total_points || 0}</div>
          </div>
          <div className="card bg-gradient-to-br from-maps-blue to-maps-navy-light text-white">
            <div className="text-sm opacity-80 mb-1">Current Level</div>
            <div className="text-4xl font-bold">{profile?.level || 1}</div>
          </div>
          <div className="card bg-gradient-to-br from-maps-coral to-maps-gold text-white">
            <div className="text-sm opacity-80 mb-1">Modules Completed</div>
            <div className="text-4xl font-bold">{profile?.modules_completed || 0}</div>
          </div>
        </div>

        <div className="grid lg:grid-cols-2 gap-8">
          <div className="card">
            <h2 className="text-xl font-bold text-maps-navy mb-6">Quick Actions</h2>
            <div className="space-y-4">
              <Link href="/practice" className="block p-4 bg-maps-teal/10 rounded-lg hover:bg-maps-teal/20 transition-colors">
                <div className="font-semibold text-maps-navy">Free Practice Chat</div>
                <div className="text-sm text-gray-600">Practice with AI personas</div>
              </Link>
              <Link href="/modules" className="block p-4 bg-maps-blue/10 rounded-lg hover:bg-maps-blue/20 transition-colors">
                <div className="font-semibold text-maps-navy">Training Modules</div>
                <div className="text-sm text-gray-600">Structured MI skill building</div>
              </Link>
            </div>
          </div>

          <div className="card">
            <h2 className="text-xl font-bold text-maps-navy mb-6">Leaderboard</h2>
            <div className="space-y-3">
              {leaderboard.map((entry, index) => (
                <div key={entry.user_id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <div className="flex items-center gap-3">
                    <span className={`w-8 h-8 flex items-center justify-center rounded-full font-bold ${
                      index === 0 ? 'bg-maps-gold text-maps-navy' :
                      index === 1 ? 'bg-gray-300 text-gray-700' :
                      index === 2 ? 'bg-orange-300 text-gray-800' :
                      'bg-gray-200 text-gray-600'
                    }`}>
                      {entry.rank}
                    </span>
                    <span className="font-medium">{entry.display_name}</span>
                  </div>
                  <span className="text-maps-teal font-semibold">{entry.total_points} pts</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
