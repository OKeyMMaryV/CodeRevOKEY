﻿#Область ПрограммныйИнтерфейс

// Добавляет в коллекцию предопределенные блоки
//
// Параметры:
//  КоллекцияБлоков - ДанныеФормыКоллекция, ТаблицаЗначений
//
Процедура ДобавитьПредопределенныеБлоки(КоллекцияБлоков) Экспорт
	
	ПредопределенныеБлоки = БлокиИнформационнойПанели.ПредопределенныеБлоки();
	
	ИменаБлоков = ОбщегоНазначения.ВыгрузитьКолонку(КоллекцияБлоков, "Имя", Истина);
	
	Для Каждого Блок Из ПредопределенныеБлоки Цикл
		Если ИменаБлоков.Найти(Блок.Имя) = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(КоллекцияБлоков.Добавить(), Блок);
			ИменаБлоков.Добавить(Блок.Имя);
		Иначе
			// Блок переопределен в расширении
		КонецЕсли;
	КонецЦикла;
	
	// Если цвет фона не задан, фон блока будет черный.
	// Черный заменяем на цвет по умолчанию, который зависит от типа интерфейса.
	НастройкиКлиента = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения");
	Если НастройкиКлиента <> Неопределено
		И НастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		ЦветПоУмолчанию = Новый Цвет;
	Иначе
		ЦветПоУмолчанию = ЦветаСтиля.ЦветФонаБлоковИнформационнойПанели;
	КонецЕсли;
	
	ЧерныйЦвет = Новый Цвет(0, 0, 0);
	Отбор = Новый Структура("ЦветФона", ЧерныйЦвет);
	
	БлокыЧерногоЦвета = КоллекцияБлоков.НайтиСтроки(Отбор);
	Для Каждого Блок Из БлокыЧерногоЦвета Цикл
		Блок.ЦветФона = ЦветПоУмолчанию;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает настройки по умолчанию
//
// Параметры:
//  Параметры - Структура параметров со свойствами, соответствующими именам блоков,значеними, являются структуры с полями:
//    * Пометка - Булево - включен/выключен блок
//    * Порядок - Число - порядковый номер блока информационной панели, используется для сортировки таблицы блоков
//
Функция НастройкаПоУмолчанию() Экспорт
	
	ИспользуетсяРазделениеДанных = РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных()
		И РаботаВМоделиСервиса.РазделениеВключено();
	
	ВыбранныеБлоки = Новый Массив();
	Если ИспользуетсяРазделениеДанных Тогда
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаОстаткиДенежныхСредств());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаПокупатели());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаПоддержкаСервиса());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаЗадачи());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаНовости());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаМетодическаяПоддержка());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаПродажи());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаПоставщики());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаОтчетность());
	Иначе
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаОстаткиДенежныхСредств());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаПокупатели());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаПродажи());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаЗадачи());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаНовости());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаМетодическаяПоддержка());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаПоставщики());
		ВыбранныеБлоки.Добавить(БлокиИнформационнойПанелиКлиентСервер.ИмяБлокаОтчетность());
	КонецЕсли;
	
	НастройкаБлоков = Новый Структура;
	
	Порядок = 0;
	Для Каждого ИмяБлока Из ВыбранныеБлоки Цикл
		ЗначенияНастроек = Новый Структура("Пометка, Порядок", Истина, Порядок);
		НастройкаБлоков.Вставить(ИмяБлока, ЗначенияНастроек);
		Порядок = Порядок + 1;
	КонецЦикла;
	
	Возврат НастройкаБлоков;
	
КонецФункции

// Загружает из хранилища и применяет пользовательские настройки информационной панели.
// Если настройки не найдены, применяет значения по умолчанию.
//
// Параметры:
//  КоллекцияБлоков - ДанныеФормыКоллекция, ТаблицаЗначений
//
Процедура ПрименитьНастройки(КоллекцияБлоков) Экспорт
	
	Перем ЗначенияНастроек; // Структура значений
	НастройкаПоУмолчанию = Неопределено;
	
	НастройкаБлоков = ХранилищеОбщихНастроек.Загрузить("ИнформационнаяПанель", "НастройкаБлоков");
	Если ТипЗнч(НастройкаБлоков) <> Тип("Структура") Тогда
		НастройкаБлоков = НастройкаПоУмолчанию();
		ОграничитьКоличествоВыводимыхПоУмолчаниюБлоков(НастройкаБлоков, КоллекцияБлоков);
	КонецЕсли;
	
	Для Каждого Блок Из КоллекцияБлоков Цикл
		
		Если НастройкаБлоков.Свойство(Блок.Имя, ЗначенияНастроек) Тогда
			ЗаполнитьЗначенияСвойств(Блок, ЗначенияНастроек);
		Иначе
			Если НастройкаПоУмолчанию = Неопределено Тогда
				НастройкаПоУмолчанию = НастройкаПоУмолчанию();
				ОграничитьКоличествоВыводимыхПоУмолчаниюБлоков(НастройкаБлоков, КоллекцияБлоков);
			КонецЕсли;
			Если НастройкаПоУмолчанию.Свойство(Блок.Имя, ЗначенияНастроек) Тогда
				ЗаполнитьЗначенияСвойств(Блок, ЗначенияНастроек);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	// При изменении настроек мог измениться порядок блоков
	КоллекцияБлоков.Сортировать("Порядок, Имя");
	
КонецПроцедуры

// Сохраняет пользовательские настройки информационной панели в хранилище
//
// Параметры:
//  Настройки - Структура параметров информационной панели
//
Процедура СохранитьНастройки(Настройки) Экспорт
	
	ХранилищеОбщихНастроек.Сохранить(
		"ИнформационнаяПанель",
		"НастройкаБлоков",
		Настройки,
		НСтр("ru = 'Настройка состава и порядка блоков Информационной панели'"));
	
КонецПроцедуры

// Процедура фонового обновления данных динамических блоков
//
// Параметры:
//  Параметры - Структура параметров со свойствами:
//     * ПроцедурыОбновленияДанных - Массив - содержит имена методов обновления данных
//     * Организация - СправочникСсылка.Организации
//     * БыстроеОбновление - Булево - способ обновления
//     * ПоказыватьСравнениеСПрошлымГодом - необходимость обновлять данные за прошлый год
//  АдресХранилища - Строка - адрес временного хранилища, в которое будет помещен результат выполнения
//
Процедура ОбновитьДанныеБлоков(Параметры, АдресХранилища) Экспорт
	
	ПередаваемыеПараметры = Новый Структура("Организация, БыстроеОбновление, ПоказыватьСравнениеСПрошлымГодом");
	ЗаполнитьЗначенияСвойств(ПередаваемыеПараметры, Параметры);
	
	ПараметрыМетодов = Новый Массив();
	ПараметрыМетодов.Добавить(ПередаваемыеПараметры);
	
	// У разных блоков может быть задана одна и та же процедура обновления.
	// Чтобы не запускать метод повторно, перед выполнением будем проверять имя метода на вхождение в соответствие.
	УникальныеЗначения = Новый Соответствие;
	
	ПроцедурыОбновленияДанных = Параметры.ПроцедурыОбновленияДанных;
	Для Каждого ИмяМетода Из ПроцедурыОбновленияДанных Цикл
		
		Если ПустаяСтрока(ИмяМетода) Тогда
			Продолжить;
		КонецЕсли;
		
		Если УникальныеЗначения[ИмяМетода] = Неопределено Тогда
			ОбщегоНазначения.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетодов);
			УникальныеЗначения.Вставить(ИмяМетода, Истина);
		Иначе
			// Метод уже вызывался
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Истина, АдресХранилища);
	
КонецПроцедуры

Процедура ОграничитьКоличествоВыводимыхПоУмолчаниюБлоков(НастройкиБлоков, КоллекцияБлоков)
	
	КоличествоОтмеченныхБлоков = 0;
	Для Каждого Настройка Из НастройкиБлоков Цикл
		
		Блоки = КоллекцияБлоков.НайтиСтроки(Новый Структура("Имя", Настройка.Ключ));
		Если Блоки.Количество() > 0 Тогда
			КоличествоОтмеченныхБлоков = КоличествоОтмеченныхБлоков + 1;
			Если КоличествоОтмеченныхБлоков > КоличествоБлоковПоУмолчанию() Тогда
				// На панель уже выведено максимальное количество блоков по умолчанию.
				// Пометка у остальных блоков снимается.
				Настройка.Значение.Пометка = Ложь;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция КоличествоСтрок() Экспорт
	
	Возврат 3;
	
КонецФункции

Функция КоличествоКолонок() Экспорт
	
	Возврат 3;
	
КонецФункции

Функция КоличествоБлоковПоУмолчанию() Экспорт
	
	Возврат 6;
	
КонецФункции

#КонецОбласти
