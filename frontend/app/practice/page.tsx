'use client';

import { useEffect, useState, useRef } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '../lib/AuthContext';
import { api, Persona } from '../lib/api';

export default function PracticePage() {
  const router = useRouter();
  const { user, loading: authLoading } = useAuth();
  const [personas, setPersonas] = useState<Persona[]>([]);
  const [selectedPersona, setSelectedPersona] = useState<Persona | null>(null);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [messages, setMessages] = useState<{ role: string; content: string }[]>([]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [analysis, setAnalysis] = useState<unknown>(null);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!authLoading && !user) {
      router.push('/login');
    }
  }, [user, authLoading, router]);

  useEffect(() => {
    async function loadPersonas() {
      try {
        const data = await api.chat.personas();
        setPersonas(data);
      } catch {
        // Fallback personas
        setPersonas([
          { id: '1', name: 'Sarah', age: 45, title: 'Career Transition', description: 'Considering a career change', stage_of_change: 'contemplation', initial_mood: 'anxious' },
          { id: '2', name: 'James', age: 32, title: 'Financial Planning', description: 'Wants to improve financial habits', stage_of_change: 'preparation', initial_mood: 'motivated' },
          { id: '3', name: 'Maria', age: 58, title: 'Retirement Planning', description: 'Preparing for retirement transition', stage_of_change: 'contemplation', initial_mood: 'uncertain' },
        ]);
      }
    }
    if (user) {
      loadPersonas();
    }
  }, [user]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  async function startSession(persona: Persona) {
    setLoading(true);
    try {
      const data = await api.chat.startSession(persona.id);
      setSessionId(data.session_id);
      setSelectedPersona(persona);
      setMessages([{ role: 'persona', content: data.opening_message }]);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Failed to start session';
      alert(msg);
    } finally {
      setLoading(false);
    }
  }

  async function sendMessage() {
    if (!input.trim() || !sessionId) return;

    const userMessage = { role: 'user', content: input };
    setMessages((prev) => [...prev, userMessage]);
    setInput('');
    setLoading(true);

    try {
      const data = await api.chat.sendMessage(sessionId, input);
      setMessages((prev) => [
        ...prev,
        { role: 'persona', content: data.response },
      ]);

      if (data.is_complete) {
        await endSession();
      }
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Failed to send message';
      alert(msg);
    } finally {
      setLoading(false);
    }
  }

  async function endSession() {
    if (!sessionId) return;

    setLoading(true);
    try {
      const data = await api.chat.endSession(sessionId);
      setAnalysis(data.analysis);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Failed to end session';
      alert(msg);
    } finally {
      setLoading(false);
    }
  }

  function resetSession() {
    setSessionId(null);
    setSelectedPersona(null);
    setMessages([]);
    setAnalysis(null);
  }

  if (authLoading) {
    return (
      <div className="page-container min-h-screen flex items-center justify-center">
        <div className="text-white text-xl">Loading...</div>
      </div>
    );
  }

  if (!user) return null;

  return (
    <div className="page-container min-h-screen">
      <nav className="bg-maps-navy/90 backdrop-blur-sm p-4">
        <div className="container mx-auto flex items-center justify-between">
          <Link href="/dashboard" className="text-2xl font-bold text-white">
            MAPS MI Training
          </Link>
          <div className="flex items-center gap-6">
            <Link href="/dashboard" className="nav-link">Dashboard</Link>
            <Link href="/modules" className="nav-link">Modules</Link>
            <Link href="/practice" className="nav-link nav-link-active">Free Practice</Link>
          </div>
        </div>
      </nav>

      <main className="container mx-auto px-4 py-8">
        {!sessionId ? (
          <>
            <div className="mb-8">
              <h1 className="text-3xl font-bold text-white mb-2">Free Practice Chat</h1>
              <p className="text-white/70">Choose a persona to practice your MI skills</p>
            </div>

            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
              {personas.map((persona) => (
                <div key={persona.id} className="card hover:shadow-xl transition-shadow">
                  <div className="flex items-center gap-4 mb-4">
                    <div className="w-16 h-16 rounded-full bg-gradient-to-br from-maps-teal to-maps-blue flex items-center justify-center text-white text-2xl font-bold">
                      {persona.name[0]}
                    </div>
                    <div>
                      <h3 className="font-bold text-lg">{persona.name}</h3>
                      <p className="text-sm text-gray-500">{persona.title}</p>
                    </div>
                  </div>
                  <p className="text-gray-600 mb-4">{persona.description}</p>
                  <div className="flex items-center justify-between text-sm">
                    <span className="bg-maps-teal/10 text-maps-teal px-3 py-1 rounded-full capitalize">
                      {persona.stage_of_change}
                    </span>
                    <button
                      onClick={() => startSession(persona)}
                      disabled={loading}
                      className="btn-primary text-sm py-2"
                    >
                      Start Chat
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </>
        ) : (
          <div className="grid lg:grid-cols-3 gap-6">
            <div className="lg:col-span-2">
              <div className="card min-h-[600px] flex flex-col">
                <div className="flex items-center justify-between mb-4 pb-4 border-b">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-gradient-to-br from-maps-teal to-maps-blue flex items-center justify-center text-white font-bold">
                      {selectedPersona?.name[0]}
                    </div>
                    <div>
                      <div className="font-semibold">{selectedPersona?.name}</div>
                      <div className="text-sm text-gray-500">{selectedPersona?.title}</div>
                    </div>
                  </div>
                  <button onClick={resetSession} className="text-gray-500 hover:text-gray-700">
                    End Session
                  </button>
                </div>

                <div className="flex-1 overflow-y-auto space-y-4 mb-4 p-4 bg-gray-50 rounded-lg">
                  {messages.map((msg, index) => (
                    <div key={index} className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'}`}>
                      <div className={`max-w-[80%] rounded-lg p-4 ${
                        msg.role === 'user'
                          ? 'bg-maps-navy text-white'
                          : 'bg-white border shadow-sm'
                      }`}>
                        {msg.content}
                      </div>
                    </div>
                  ))}
                  {loading && (
                    <div className="flex justify-start">
                      <div className="bg-white border shadow-sm rounded-lg p-4">
                        <span className="animate-pulse">Thinking...</span>
                      </div>
                    </div>
                  )}
                  <div ref={messagesEndRef} />
                </div>

                {!analysis && (
                  <div className="flex gap-4">
                    <input
                      type="text"
                      value={input}
                      onChange={(e) => setInput(e.target.value)}
                      onKeyPress={(e) => e.key === 'Enter' && sendMessage()}
                      placeholder="Type your message..."
                      className="input flex-1"
                      disabled={loading}
                    />
                    <button onClick={sendMessage} className="btn-primary" disabled={loading}>
                      Send
                    </button>
                  </div>
                )}
              </div>
            </div>

            <div>
              <div className="card">
                <h3 className="font-bold text-lg mb-4">Session Tips</h3>
                <ul className="space-y-2 text-sm text-gray-600">
                  <li>• Use open-ended questions</li>
                  <li>• Practice reflective listening</li>
                  <li>• Listen for change talk</li>
                  <li>• Roll with resistance</li>
                  <li>• Support self-efficacy</li>
                </ul>
              </div>

              {analysis && (
                <div className="card mt-6">
                  <h3 className="font-bold text-lg mb-4">Session Analysis</h3>
                  <div className="space-y-4">
                    <div>
                      <div className="text-sm text-gray-600">Overall Score</div>
                      <div className="text-3xl font-bold text-maps-teal">
                        {(analysis as { overall_score?: number })?.overall_score?.toFixed(1) || 'N/A'}
                      </div>
                    </div>
                    <div>
                      <div className="text-sm text-gray-600">MI Spirit Score</div>
                      <div className="text-2xl font-semibold">
                        {(analysis as { mi_spirit_score?: number })?.mi_spirit_score?.toFixed(1) || 'N/A'}
                      </div>
                    </div>
                    {(analysis as { strengths?: string[] })?.strengths && (
                      <div>
                        <div className="text-sm text-gray-600 mb-1">Strengths</div>
                        <ul className="text-sm space-y-1">
                          {(analysis as { strengths: string[] }).strengths.slice(0, 3).map((s, i) => (
                            <li key={i} className="text-green-700">• {s}</li>
                          ))}
                        </ul>
                      </div>
                    )}
                    {(analysis as { areas_for_improvement?: string[] })?.areas_for_improvement && (
                      <div>
                        <div className="text-sm text-gray-600 mb-1">Areas to Improve</div>
                        <ul className="text-sm space-y-1">
                          {(analysis as { areas_for_improvement: string[] }).areas_for_improvement.slice(0, 3).map((s, i) => (
                            <li key={i} className="text-maps-coral">• {s}</li>
                          ))}
                        </ul>
                      </div>
                    )}
                  </div>
                  <button onClick={resetSession} className="btn-primary w-full mt-6">
                    Start New Session
                  </button>
                </div>
              )}
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
