-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ---------------------------------------
-- Categories
-- ---------------------------------------
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    parentId UUID,
    imageUrl TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedAt TIMESTAMP NOT NULL DEFAULT NOW(),
    deletedAt TIMESTAMP,

    FOREIGN KEY (parentId) REFERENCES categories(id)
);

-- ---------------------------------------
-- Products
-- ---------------------------------------
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    discountPrice NUMERIC(10,2),
    stock INTEGER NOT NULL DEFAULT 0,
    sku TEXT NOT NULL UNIQUE,
    brand TEXT,
    categoryId UUID NOT NULL,
    imageUrls TEXT[] NOT NULL,
    sizes TEXT[],
    colors TEXT[],
    material TEXT,
    gender TEXT CHECK (gender IN ('Men', 'Women', 'Unisex')),
    tags TEXT[],
    isFeatured BOOLEAN DEFAULT FALSE,
    active BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedAt TIMESTAMP NOT NULL DEFAULT NOW(),
    deletedAt TIMESTAMP,

    FOREIGN KEY (categoryId) REFERENCES categories(id)
);

-- ---------------------------------------
-- Users
-- ---------------------------------------
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    firstName TEXT NOT NULL,
    lastName TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    passwordHash TEXT NOT NULL,
    phone TEXT,
    role TEXT DEFAULT 'CUSTOMER' CHECK (role IN ('CUSTOMER', 'ADMIN')),
    avatarUrl TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedAt TIMESTAMP NOT NULL DEFAULT NOW(),
    deletedAt TIMESTAMP
);

-- ---------------------------------------
-- Addresses
-- ---------------------------------------
CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    userId UUID NOT NULL,
    fullName TEXT NOT NULL,
    phone TEXT NOT NULL,
    street TEXT NOT NULL,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    country TEXT NOT NULL,
    postalCode TEXT NOT NULL,
    isDefault BOOLEAN DEFAULT FALSE,
    createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedAt TIMESTAMP NOT NULL DEFAULT NOW(),
    deletedAt TIMESTAMP,

    FOREIGN KEY (userId) REFERENCES users(id)
);

-- ---------------------------------------
-- Cart
-- ---------------------------------------
CREATE TABLE carts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    userId UUID NOT NULL UNIQUE,
    totalQuantity INTEGER NOT NULL DEFAULT 0,
    totalPrice NUMERIC(10,2) NOT NULL DEFAULT 0,
    createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedAt TIMESTAMP NOT NULL DEFAULT NOW(),
    deletedAt TIMESTAMP,

    FOREIGN KEY (userId) REFERENCES users(id)
);

CREATE TABLE cart_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cartId UUID NOT NULL,
    productId UUID NOT NULL,
    quantity INTEGER NOT NULL,
    size TEXT,
    color TEXT,

    FOREIGN KEY (cartId) REFERENCES carts(id),
    FOREIGN KEY (productId) REFERENCES products(id)
);

-- ---------------------------------------
-- Orders
-- ---------------------------------------
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    userId UUID NOT NULL,
    items JSONB NOT NULL,
    totalAmount NUMERIC(10,2) NOT NULL,
    paymentStatus TEXT NOT NULL CHECK (paymentStatus IN ('PENDING','PAID','FAILED','REFUNDED')),
    orderStatus TEXT NOT NULL CHECK (orderStatus IN ('PENDING','PROCESSING','SHIPPED','DELIVERED','CANCELLED')),
    shippingAddressId UUID NOT NULL,
    trackingNumber TEXT,
    notes TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedAt TIMESTAMP NOT NULL DEFAULT NOW(),
    deletedAt TIMESTAMP,

    FOREIGN KEY (userId) REFERENCES users(id),
    FOREIGN KEY (shippingAddressId) REFERENCES addresses(id)
);

-- ---------------------------------------
-- Reviews
-- ---------------------------------------
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    userId UUID NOT NULL,
    productId UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    verifiedPurchase BOOLEAN DEFAULT FALSE,
    createdAt TIMESTAMP NOT NULL DEFAULT NOW(),
    updatedAt TIMESTAMP NOT NULL DEFAULT NOW(),
    deletedAt TIMESTAMP,

    FOREIGN KEY (userId) REFERENCES users(id),
    FOREIGN KEY (productId) REFERENCES products(id)
);

-- ---------------------------------------
-- Banners
-- ---------------------------------------
CREATE TABLE banners (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    subtitle TEXT,
    imageUrl TEXT NOT NULL,
    linkUrl TEXT,
    active BOOLEAN DEFAULT TRUE
);

-- ---------------------------------------
-- Promo Codes
-- ---------------------------------------
CREATE TABLE promo_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code TEXT NOT NULL UNIQUE,
    discountPercentage INTEGER NOT NULL,
    validFrom TIMESTAMP NOT NULL,
    validUntil TIMESTAMP NOT NULL,
    isActive BOOLEAN DEFAULT TRUE
);

-- ---------------------------------------
-- Store Metadata (single row recommended)
-- ---------------------------------------
CREATE TABLE store_metadata (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slogan TEXT NOT NULL,
    description TEXT NOT NULL,
    logoUrl TEXT,
    supportEmail TEXT,
    supportPhone TEXT,
    currency TEXT
);
