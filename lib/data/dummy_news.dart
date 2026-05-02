import '../models/news_item.dart';

final List<NewsItem> dummyNews = <NewsItem>[
  NewsItem(
    id: 'n1',
    title: 'AI Bantu Produktivitas Tim Jarak Jauh Meningkat 2x Lipat',
    description:
        'Perusahaan teknologi melaporkan kenaikan produktivitas setelah adopsi AI assistant.',
    content:
        'Adopsi alat berbasis AI dalam workflow harian menunjukkan dampak signifikan pada kecepatan kerja. Tim dapat merangkum rapat, menyusun draf dokumen, dan mengotomatiskan tugas repetitif dengan lebih efisien. Para analis menilai tren ini akan terus tumbuh di 2 tahun ke depan.',
    category: 'Technology',
    date: DateTime(2026, 4, 26),
    readMinutes: 6,
    imageHint: 'AI Office',
    featured: true,
    trendingScore: 98,
  ),
  NewsItem(
    id: 'n2',
    title: 'Ekonomi Hijau Dorong Investasi Baru di Asia Tenggara',
    description:
        'Nilai investasi proyek energi bersih meningkat tajam pada kuartal pertama 2026.',
    content:
        'Investasi pada energi surya, angin, dan kendaraan listrik meningkat berkat kebijakan fiskal baru. Pemerintah dan swasta berkolaborasi membangun infrastruktur yang lebih ramah lingkungan. Dampaknya diprediksi menciptakan lapangan kerja baru secara luas.',
    category: 'Economy',
    date: DateTime(2026, 4, 25),
    readMinutes: 5,
    imageHint: 'Green Energy',
    featured: true,
    trendingScore: 92,
  ),
  NewsItem(
    id: 'n3',
    title: 'Kota Cerdas Mulai Terapkan Sistem Transportasi Prediktif',
    description:
        'Sistem baru memanfaatkan data real-time untuk menekan kemacetan jam sibuk.',
    content:
        'Penggunaan sensor, kamera, dan machine learning membantu pengelola kota mengatur lampu lalu lintas secara dinamis. Hasil awal menunjukkan pengurangan waktu tempuh rata-rata hingga 18 persen pada koridor utama.',
    category: 'Urban',
    date: DateTime(2026, 4, 24),
    readMinutes: 4,
    imageHint: 'Smart City',
    trendingScore: 88,
  ),
  NewsItem(
    id: 'n4',
    title: 'Gaya Hidup Minimalis Kembali Populer di Kalangan Profesional Muda',
    description:
        'Tren hidup sederhana dianggap membantu kesehatan mental dan fokus kerja.',
    content:
        'Komunitas digital minimalism bertumbuh di berbagai kota besar. Banyak pengguna mengurangi distraksi digital dan memprioritaskan rutinitas yang lebih sehat. Psikolog menilai pendekatan ini relevan untuk era informasi cepat.',
    category: 'Lifestyle',
    date: DateTime(2026, 4, 22),
    readMinutes: 7,
    imageHint: 'Minimalist Living',
    trendingScore: 84,
  ),
  NewsItem(
    id: 'n5',
    title: 'Startup EdTech Lokal Rilis Platform Belajar Adaptif',
    description:
        'Platform menyesuaikan materi sesuai kemampuan dan ritme belajar pengguna.',
    content:
        'Dengan machine learning, platform baru dapat memetakan kelemahan konsep pengguna dan memberi latihan personal. Uji coba awal pada siswa SMA menunjukkan peningkatan pemahaman materi matematika dasar.',
    category: 'Education',
    date: DateTime(2026, 4, 21),
    readMinutes: 5,
    imageHint: 'Online Learning',
    trendingScore: 81,
  ),
  NewsItem(
    id: 'n6',
    title: 'Liga Sepak Bola Nasional Catat Rekor Penonton Musim Ini',
    description:
        'Antusiasme suporter naik berkat format kompetisi baru dan ticketing digital.',
    content:
        'Perbaikan fasilitas stadion, pengalaman digital, dan jadwal pertandingan yang lebih konsisten mendorong kenaikan jumlah penonton. Pihak liga menargetkan ekspansi pasar regional musim depan.',
    category: 'Sports',
    date: DateTime(2026, 4, 20),
    readMinutes: 3,
    imageHint: 'Football Stadium',
    trendingScore: 77,
  ),
];
