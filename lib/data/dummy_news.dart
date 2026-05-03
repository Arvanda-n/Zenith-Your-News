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
    imageUrl:
        'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=1200&q=80',
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
    imageUrl:
        'https://images.unsplash.com/photo-1466611653911-95081537e5b7?auto=format&fit=crop&w=1200&q=80',
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
    imageUrl:
        'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?auto=format&fit=crop&w=1200&q=80',
    featured: true,
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
    imageUrl:
        'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1200&q=80',
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
    imageUrl:
        'https://images.unsplash.com/photo-1509062522246-3755977927d7?auto=format&fit=crop&w=1200&q=80',
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
    imageUrl:
        'https://images.unsplash.com/photo-1547347298-4074fc3086f0?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 77,
  ),
  NewsItem(
    id: 'n7',
    title: 'Peneliti Lokal Temukan Baterai Cepat Isi untuk Motor Listrik',
    description:
        'Prototipe baru diklaim memangkas waktu pengisian hingga setengahnya.',
    content:
        'Tim riset kampus dan industri mengembangkan material baterai baru yang meningkatkan efisiensi termal saat pengisian daya. Jika lolos uji produksi massal, teknologi ini berpotensi mempercepat adopsi kendaraan listrik roda dua di Indonesia.',
    category: 'Innovation',
    date: DateTime(2026, 4, 19),
    readMinutes: 6,
    imageHint: 'Electric Battery',
    imageUrl:
        'https://images.unsplash.com/photo-1593941707882-a5bac6861d75?auto=format&fit=crop&w=1200&q=80',
    featured: true,
    trendingScore: 90,
  ),
  NewsItem(
    id: 'n8',
    title: 'Wisata Bahari Timur Indonesia Menarik Lonjakan Pengunjung Premium',
    description:
        'Operator tur mencatat kenaikan pemesanan paket pengalaman eksklusif.',
    content:
        'Destinasi laut di kawasan timur Indonesia semakin diminati oleh wisatawan domestik dan internasional. Pelaku usaha menyebut kombinasi konservasi, layanan privat, dan promosi digital menjadi pendorong utama tren ini.',
    category: 'Travel',
    date: DateTime(2026, 4, 18),
    readMinutes: 4,
    imageHint: 'Ocean Travel',
    imageUrl:
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 76,
  ),
  NewsItem(
    id: 'n9',
    title: 'Brand Fashion Lokal Uji Coba Produksi Berbasis Daur Ulang',
    description:
        'Koleksi baru memanfaatkan limbah tekstil untuk lini pakaian harian.',
    content:
        'Beberapa label fashion lokal mulai membangun rantai pasok sirkular dengan memanfaatkan bahan sisa produksi. Konsumen muda disebut menjadi segmen paling responsif terhadap produk yang menonjolkan transparansi bahan dan jejak lingkungan.',
    category: 'Business',
    date: DateTime(2026, 4, 17),
    readMinutes: 5,
    imageHint: 'Sustainable Fashion',
    imageUrl:
        'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 74,
  ),
  NewsItem(
    id: 'n10',
    title: 'Rumah Sakit Gunakan AI Triage untuk Percepat Layanan Darurat',
    description:
        'Sistem membantu prioritisasi pasien berdasarkan gejala awal dan risiko.',
    content:
        'Beberapa rumah sakit di kota besar mulai menguji sistem triage berbasis AI untuk mempersingkat waktu tunggu pasien gawat darurat. Tenaga medis tetap menjadi pengambil keputusan utama, tetapi sistem baru membantu menyusun prioritas dengan lebih cepat.',
    category: 'Health',
    date: DateTime(2026, 4, 16),
    readMinutes: 7,
    imageHint: 'Hospital AI',
    imageUrl:
        'https://images.unsplash.com/photo-1516549655169-df83a0774514?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 86,
  ),
];
