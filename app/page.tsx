import Link from "next/link";

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-maps-navy via-maps-navy-light to-maps-blue">
      <div className="container mx-auto px-4 py-16">
        {/* Hero Section */}
        <div className="text-center mb-16">
          <h1 className="text-5xl md:text-6xl font-bold text-white mb-6">
            MAPS
          </h1>
          <p className="text-xl md:text-2xl text-maps-teal-light mb-4">
            AI Persona System for Motivational Interviewing Training
          </p>
          <p className="text-lg text-gray-300 max-w-2xl mx-auto mb-8">
            Practice MI techniques with sophisticated AI personas, receive real-time feedback,
            and track your progress with our comprehensive analysis system.
          </p>
        </div>

        {/* Feature Cards */}
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
          <FeatureCard
            title="AI Persona Chat"
            description="Engage in realistic conversations with nuanced AI personas"
            icon="💬"
          />
          <FeatureCard
            title="MI Practice Modules"
            description="45+ structured modules for skill development"
            icon="📚"
          />
          <FeatureCard
            title="Voice Interaction"
            description="Practice with real-time voice transcription"
            icon="🎤"
          />
          <FeatureCard
            title="MAPS Analysis"
            description="Sophisticated feedback on MI adherent behaviors"
            icon="📊"
          />
        </div>

        {/* CTA Buttons */}
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Link
            href="/login"
            className="btn-primary text-center text-lg px-8 py-4"
          >
            Get Started
          </Link>
          <Link
            href="/demo"
            className="btn-outline border-white text-white hover:bg-white hover:text-maps-navy text-center text-lg px-8 py-4"
          >
            Try Demo
          </Link>
        </div>

        {/* Info Section */}
        <div className="mt-16 text-center text-gray-400">
          <p>Full integration with Supabase for secure authentication and data storage</p>
          <p className="mt-2">Powered by OpenAI GPT-4o-mini and Mistral Audio</p>
        </div>
      </div>
    </div>
  );
}

function FeatureCard({
  title,
  description,
  icon,
}: {
  title: string;
  description: string;
  icon: string;
}) {
  return (
    <div className="card bg-white/10 backdrop-blur-sm border-white/20 hover:bg-white/15 transition-all">
      <div className="text-4xl mb-4">{icon}</div>
      <h3 className="text-xl font-semibold text-white mb-2">{title}</h3>
      <p className="text-gray-300">{description}</p>
    </div>
  );
}
