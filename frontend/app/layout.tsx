import type { Metadata } from 'next';
import './styles/globals.css';
import { Providers } from './providers';

export const metadata: Metadata = {
  title: 'MAPS MI Learning Platform',
  description: 'AI Persona System for Motivational Interviewing Training',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
