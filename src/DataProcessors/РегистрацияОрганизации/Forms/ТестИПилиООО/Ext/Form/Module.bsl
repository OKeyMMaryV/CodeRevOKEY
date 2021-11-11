﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Обработки.РегистрацияОрганизации.ИспользуетсяСервисРегистрации() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Сервис регистрации недоступен'"), , , , Отказ);
		Возврат;
	КонецЕсли;
	
	Обработки.РегистрацияОрганизации.РазместитьНавигацию(ЭтотОбъект, Параметры);
	
	Если ЭтоТест(НавигацияПараметрФормы) Тогда
		ПройтиТестНаСервере();
	ИначеЕсли ЭтоПодтверждениеФормыБизнеса(НавигацияПараметрФормы) Тогда
		ПодготовитьТекстыПодтвержденияФормыБизнеса();
		УстановитьОтображениеФормы("ГруппаПодтверждениеФормуБизнеса");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РегистрацияОрганизацииКлиент.ОповеститьОбОткрытии(ЭтотОбъект,
		РегистрацияОрганизацииКлиентСервер.ИмяПомощникаРегистрации(),
		НавигацияНомерШага);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = ЭтотОбъект Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "ОткрытШагПомощника_РегистрацияОрганизации" Тогда
		Если Параметр = Неопределено
			Или Параметр.ИмяПомощника <> РегистрацияОрганизацииКлиентСервер.ИмяПомощникаРегистрации()
			Или Параметр.НомерШага <> НавигацияНомерШага Тогда
			Закрыть();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ЗавершенаРаботаПомощникаНачалаРаботы" Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	РегистрацияОрганизацииКлиент.ОбработатьНавигационнуюСсылку(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "Тест" Тогда
		СтандартнаяОбработка = Ложь;
		ПройтиТестНаСервере();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РегистрацияИП(Команда)
	
	СохранитьФормуБизнеса(Ложь);
	РегистрацияОрганизацииКлиент.ОткрытьЭтап(НавигацияНомерШага + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияООО(Команда)
	
	СохранитьФормуБизнеса(Истина);
	РегистрацияОрганизацииКлиент.ОткрытьЭтап(НавигацияНомерШага + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	РегистрацияОрганизацииКлиент.ОткрытьЭтап(НавигацияНомерШага - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	РегистрацияОрганизацииКлиент.ОткрытьЭтап(НавигацияНомерШага + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПройтиТест(Команда)
	
	ПройтиТестНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветДа(Команда)
	
	ЗарегистрироватьОтвет(Истина);
	ПерейтиКВопросу(ТекущийВопрос + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНет(Команда)
	
	ЗарегистрироватьОтвет(Ложь);
	ПерейтиКВопросу(ТекущийВопрос + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветНазад(Команда)
	
	Если ТекущийВопрос = 1 Тогда
		УстановитьОтображениеФормы("ГруппаФормаБизнеса");
	Иначе
		ЗарегистрироватьОтвет(Неопределено);
		ПерейтиКВопросу(ТекущийВопрос - 1);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтображениеФормы(ИмяТекущейГруппы)

	МассивГруппФормы = Новый Массив;
	МассивГруппФормы.Добавить("ГруппаФормаБизнеса");
	МассивГруппФормы.Добавить("ГруппаРезультатТеста");
	МассивГруппФормы.Добавить("ГруппаТест");
	МассивГруппФормы.Добавить("ГруппаПодтверждениеФормуБизнеса");
	
	Для Каждого ИмяГруппы Из МассивГруппФормы Цикл
		Если ИмяГруппы = ИмяТекущейГруппы Тогда
			Продолжить;
		КонецЕсли;
		Элементы[ИмяГруппы].Видимость = Ложь;
	КонецЦикла;
	
	Элементы[ИмяТекущейГруппы].Видимость = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПройтиТестНаСервере()
	
	РезультатТеста = Новый Структура;
	ДанныеТеста = ПодготовитьДанныеТеста();
	ПерейтиКВопросу(1);
	УстановитьОтображениеФормы("ГруппаТест");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодготовитьДанныеТеста()

	ДанныеТеста = Новый Структура;
	МакетТеста = Обработки.РегистрацияОрганизации.ПолучитьМакет("ВопросыТеста");
	
	ОбластьМакета = МакетТеста.ПолучитьОбласть("Вопросы");
	КоличествоВопросов = ОбластьМакета.ВысотаТаблицы;
	ДанныеТеста.Вставить("КоличествоВопросов", КоличествоВопросов);
	Вопросы = Новый Массив;
	Для НомерСтроки = 1 По КоличествоВопросов Цикл
		
		ВопросТеста = Новый Структура("Вопрос, Информация, ДопДанные, КнопкаДа, КнопкаНет, ЕслиДа, ЕслиНет",
			ОбластьМакета.Область(НомерСтроки, 1).Текст,
			ОбластьМакета.Область(НомерСтроки, 2).Текст,
			ОбластьМакета.Область(НомерСтроки, 3).Текст,
			ОбластьМакета.Область(НомерСтроки, 4).Текст,
			ОбластьМакета.Область(НомерСтроки, 5).Текст,
			ОбластьМакета.Область(НомерСтроки, 6).Текст,
			ОбластьМакета.Область(НомерСтроки, 7).Текст);
		Вопросы.Добавить(ВопросТеста);
		
	КонецЦикла;
	ДанныеТеста.Вставить("Вопросы", Вопросы);
	
	ДанныеТеста.Вставить("ВыигралИП",
		ПолучитьОбластьРезультата(МакетТеста, "ВыигралИП"));
		
	ДанныеТеста.Вставить("ВыигралООО",
		ПолучитьОбластьРезультата(МакетТеста, "ВыигралООО"));
		
	ДанныеТеста.Вставить("ПодходитТолькоООО",
		ПолучитьОбластьРезультата(МакетТеста, "ПодходитТолькоООО"));
		
	ДанныеТеста.Вставить("Ничья",
		ПолучитьОбластьРезультата(МакетТеста, "Ничья"));
	
	Возврат ДанныеТеста;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьОбластьРезультата(Знач МакетТеста, Знач ИмяОбласти)
	
	ОбластьМакета = МакетТеста.ПолучитьОбласть(ИмяОбласти);
	РезультатТеста = Новый Структура("Результат, Информация, Пожелание");
	РезультатТеста.Результат	 = ОбластьМакета.Область(1, 1).Текст;
	РезультатТеста.Информация	 = ОбластьМакета.Область(1, 2).Текст;
	РезультатТеста.Пожелание	 = ОбластьМакета.Область(1, 3).Текст;
	
	Возврат РезультатТеста;
	
КонецФункции

&НаСервере
Процедура ПерейтиКВопросу(НомерВопроса)
	
	ТекущийВопрос = НомерВопроса;
	
	Если ТекущийВопрос > ДанныеТеста.КоличествоВопросов Тогда
		ПоказатьРезультатыТеста();
	ИначеЕсли ТекущийВопрос > 0 Тогда
		ОтобразитьВопросТеста(ТекущийВопрос);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьВопросТеста(НомерВопроса)
	
	СписокВопросов = ДанныеТеста.Вопросы;
	ВопросТеста = СписокВопросов[НомерВопроса - 1];
	Элементы.НадписьНомерВопроса.Заголовок =
		СтрШаблон(НСтр("ru = 'Вопрос %1 из %2'"), НомерВопроса, ДанныеТеста.КоличествоВопросов);
	Элементы.НадписьВопрос.Заголовок = ВопросТеста.Вопрос;
	
	ОтветственностьАСВ = НСтр("ru = 'в 1,4 млн. руб.'");
	ОтветственностьАСВ_НПП = СтрЗаменить(ОтветственностьАСВ, " ", Символы.НПП); // Заменяем здесь, т.к. по дороге из макета НПП теряются
	Элементы.НадписьПояснение.Заголовок = СтрЗаменить(ВопросТеста.Информация, ОтветственностьАСВ, ОтветственностьАСВ_НПП);
	
	Элементы.НадписьДопИнформация.Видимость = Не ПустаяСтрока(ВопросТеста.ДопДанные);
	Элементы.НадписьДопИнформация.Заголовок = ВопросТеста.ДопДанные;
	
	Элементы.ОтветДа.Заголовок = ВопросТеста.КнопкаДа;
	Элементы.ОтветНет.Заголовок = ВопросТеста.КнопкаНет;
	ТекущийЭлемент = Элементы.ОтветДа;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьОтвет(Ответ)
	
	КлючОтвета = СтрШаблон("Вопрос%1", Формат(ТекущийВопрос, "ЧДЦ=; ЧГ=0"));
	Если ЗначениеЗаполнено(Ответ) Тогда
		ВопросТеста = ДанныеТеста.Вопросы[ТекущийВопрос - 1];
		РезультатТеста.Вставить(КлючОтвета, ?(Ответ, ВопросТеста.ЕслиДа, ВопросТеста.ЕслиНет));
	ИначеЕсли РезультатТеста.Свойство(КлючОтвета) Тогда
		РезультатТеста.Удалить(КлючОтвета);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьРезультатыТеста()
	
	БаллыИП		 = 0;
	БаллыООО	 = 0;
	ТолькоООО	 = Ложь;
	Для Каждого Элемент Из РезультатТеста Цикл
		
		Если Элемент.Значение = "ИП" Тогда
			
			БаллыИП = БаллыИП + 1;
			
		ИначеЕсли Элемент.Значение = "ООО" Тогда
			
			БаллыООО = БаллыООО + 1;
			
		ИначеЕсли Элемент.Значение = "ТолькоООО" Тогда
			
			ТолькоООО = Истина;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	МакетТеста = Обработки.РегистрацияОрганизации.ПолучитьМакет("ВопросыТеста");
	ВыбранИП = (ВидОрганизации = НСтр("ru='ИП'"));
	Если ТолькоООО Тогда
		
		Победитель = ДанныеТеста.ПодходитТолькоООО;
		БаллыИП = 0;
		БаллыООО = 1;
		
		Элементы.РезультатРегистрацияИП.ЦветФона	 = ЦветаСтиля.ЦветФонаФормы;
		Элементы.РезультатРегистрацияООО.ЦветФона	 = ЦветаСтиля.ВыборСтандартногоПериодаФонКнопки;
		ТекущийЭлемент = Элементы.РезультатРегистрацияООО;
		ПравильныйВыбор = НЕ ВыбранИП;
		
	ИначеЕсли БаллыИП > БаллыООО Тогда
		
		Победитель = ДанныеТеста.ВыигралИП;
		Элементы.РезультатРегистрацияИП.ЦветФона	 = ЦветаСтиля.ВыборСтандартногоПериодаФонКнопки;
		Элементы.РезультатРегистрацияООО.ЦветФона	 = ЦветаСтиля.ЦветФонаФормы;
		ТекущийЭлемент = Элементы.РезультатРегистрацияИП;
		ПравильныйВыбор = ВыбранИП;
		
	ИначеЕсли БаллыИП = БаллыООО Тогда
		
		Победитель = ДанныеТеста.Ничья;
		Элементы.РезультатРегистрацияИП.ЦветФона	 = ЦветаСтиля.ВыборСтандартногоПериодаФонКнопки;
		Элементы.РезультатРегистрацияООО.ЦветФона	 = ЦветаСтиля.ЦветФонаФормы;
		ТекущийЭлемент = Элементы.РезультатРегистрацияИП;
		ПравильныйВыбор = Истина;
		
	Иначе
		
		Победитель = ДанныеТеста.ВыигралООО;
		Элементы.РезультатРегистрацияИП.ЦветФона	 = ЦветаСтиля.ЦветФонаФормы;
		Элементы.РезультатРегистрацияООО.ЦветФона	 = ЦветаСтиля.ВыборСтандартногоПериодаФонКнопки;
		ТекущийЭлемент = Элементы.РезультатРегистрацияООО;
		ПравильныйВыбор = НЕ ВыбранИП;
		
	КонецЕсли;
	Элементы.НадписьРезультатКтоПодходит.Заголовок	 = Победитель.Результат;
	Элементы.НадписьРезультатИнформация.Заголовок	 = Победитель.Информация;
	Элементы.НадписьРезультатПожелание.Заголовок	 = Победитель.Пожелание;
	
	УстановитьОтображениеФормы("ГруппаРезультатТеста");
	
	Точка = РезультатДиаграмма.УстановитьТочку(0);
	
	Серия = РезультатДиаграмма.УстановитьСерию("ИП");
	РезультатДиаграмма.УстановитьЗначение(Точка, Серия, БаллыИП);
	
	Серия = РезультатДиаграмма.УстановитьСерию("ООО");
	РезультатДиаграмма.УстановитьЗначение(Точка, Серия, БаллыООО);
	
	РезультатДиаграмма.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.БезРамки);
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		
		// в Firefox возникают проблемы с анимацией, отключаем его
		СисИнфо = Новый СистемнаяИнформация;
		ВебБраузер = СисИнфо.ИнформацияПрограммыПросмотра;
		Если СтрЧислоВхождений(ВРег(ВебБраузер), "FIREFOX") > 0 Тогда
			РезультатДиаграмма.Анимация = АнимацияДиаграммы.НеИспользовать;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЭтоПодтверждениеФормыБизнеса(НавигацияПараметрФормы) Тогда
		Элементы.СтраницыДальнейшиеДействия.ТекущаяСтраница = Элементы.ГруппаВыборФормаБизнеса;
	ИначеЕсли ПравильныйВыбор Тогда
		Элементы.СтраницыДальнейшиеДействия.ТекущаяСтраница = Элементы.ГруппаПодтверждениеВыбора;
	Иначе
		Элементы.СтраницыДальнейшиеДействия.ТекущаяСтраница = Элементы.ГруппаРезультатНеСовпал;
		Элементы.КомандаДалееРезультатыТеста.Заголовок = СтрШаблон(НСтр("ru='Регистрация %1'"), ВидОрганизации);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьТекстыПодтвержденияФормыБизнеса()
	
	ДанныеПомощникаРегистрации = Обработки.РегистрацияОрганизации.ДанныеПомощникаРегистрации();
	
	НалоговыйРежим = ДанныеПомощникаРегистрации.Налоги.ВыбранныйРежим;
	ВидОрганизации = ВидОрганизации(НалоговыйРежим);
	
	Элементы.НадписьЗначениеВыбора.Заголовок = СтрШаблон(
		НСтр("ru='%1 на %2'"),
		ВидОрганизации,
		СистемаНалогообложения(НалоговыйРежим));
	Элементы.НадписьПредложениеПройтиТест.Заголовок = Новый ФорматированнаяСтрока(
		СтрШаблон(НСтр("ru='Не уверены, что вам подходит именно %1?'"), ВидОрганизации),
		" ",
		Новый ФорматированнаяСтрока(НСтр("ru='Пройти тест.'"),,,,"Тест"));
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция СистемаНалогообложения(Знач НалоговыйРежим)
	
	Если СтрНайти(НалоговыйРежим, "УСНДоходыРасходы") Тогда
		СистемаНалогообложения = НСтр("ru='УСН (доходы - расходы)'");
	ИначеЕсли СтрНайти(НалоговыйРежим, "УСНДоходы") Тогда
		СистемаНалогообложения = НСтр("ru='УСН (доходы)'");
	ИначеЕсли СтрНайти(НалоговыйРежим, "ЕНВД") Тогда
		СистемаНалогообложения = НСтр("ru='ЕНВД'");
	ИначеЕсли СтрНайти(НалоговыйРежим, "ПСН") Тогда
		СистемаНалогообложения = НСтр("ru='патенте'");
	Иначе
		СистемаНалогообложения = НСтр("ru='общем режиме'");
	КонецЕсли;
	
	Возврат СистемаНалогообложения;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВидОрганизации(Знач НалоговыйРежим)
	
	Если СтрНайти(НалоговыйРежим, "ИП") Тогда
		ВидОрганизации = НСтр("ru='ИП'");
	Иначе
		ВидОрганизации = НСтр("ru='ООО'");
	КонецЕсли;
	
	Возврат ВидОрганизации;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоПодтверждениеФормыБизнеса(Знач НавигацияПараметрФормы)

	Возврат НавигацияПараметрФормы = "ПодтвердитьФормуБизнеса";

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоТест(Знач НавигацияПараметрФормы)

	Возврат НавигацияПараметрФормы = "ПройтиТест";

КонецФункции

&НаСервере
Процедура СохранитьФормуБизнеса(ЭтоЮрЛицо)
	
	ФормаБизнеса = ?(ЭтоЮрЛицо,
		Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо,
		Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
	Обработки.РегистрацияОрганизации.СохранитьДанныеФормаБизнеса(ФормаБизнеса);
	Обработки.РегистрацияОрганизации.ОбновитьНавигациюФормы(ЭтаФорма, Ложь);
	
КонецПроцедуры

#КонецОбласти
