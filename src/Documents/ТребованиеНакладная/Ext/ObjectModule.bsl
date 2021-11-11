﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ОбработкаЗаполнения(ДанныеЗаполнения)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено
			И ТипДанныхЗаполнения <> Тип("Структура")
			И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
		
		//ОК Калинин М. 171012 Регистрируем основание
		ДокументОснование = ДанныеЗаполнения;
		//ОК Калинин М.
		
		//ОК Калинин М. 231112
		Попытка
			ОК_ID_Разноска = ДанныеЗаполнения.ОК_ID_Разноска;
		Исключение
		КонецПопытки;
	
		//ОК Калинин М.		
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения, Истина);
	
	Документы.ТребованиеНакладная.ЗаполнитьСоставКомиссии(СоставКомиссии, Организация);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	НДСвСтоимостиТоваров = Перечисления.ДействиеНДСВСтоимостиТоваров.НеИзменять;
	ДляСписанияНДСИспользоватьСчетИАналитикуУчетаЗатрат = Ложь;
	
	Если Материалы.Количество() > 0 Тогда
		МассивМатериалы = Новый Массив(Материалы.Количество());
		
		Материалы.ЗагрузитьКолонку(МассивМатериалы, "Себестоимость");
		Материалы.ЗагрузитьКолонку(МассивМатериалы, "ДокументОприходования");
	КонецЕсли;
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-08-02 (#4214)
	ВедетсяУчетПрослеживаемыхТоваров = ПолучитьФункциональнуюОпцию("ВестиУчетПрослеживаемыхТоваров")
		И ПрослеживаемостьБРУ.ВедетсяУчетПрослеживаемыхТоваров(Дата);
	
	СведенияПрослеживаемости.Очистить();
	РаботаСНоменклатурой.ОбновитьПризнакПрослеживаемости(Материалы, ВедетсяУчетПрослеживаемыхТоваров);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-08-02 (#4214)
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Документ без данных о движении материалов не считаем заполненным корректно.
	// Следует заполнить данные в любой из табличных частей.
	ОбщегоНазначенияБП.ИсключитьИзПроверкиОсновныеТабличныеЧасти(
		ЭтотОбъект, 
		"Материалы,МатериалыЗаказчика",
		ПроверяемыеРеквизиты);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ПроверяемыеРеквизиты.Найти("Склад") = Неопределено Тогда
		ПроверяемыеРеквизиты.Добавить("Склад");
	КонецЕсли;

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-27 (#4405)
	Если ВидОперации = Перечисления.ВидыОперацийРасходМатериалов.ПередачаСотруднику Тогда
		ПроверяемыеРеквизиты.Добавить("Сотрудник");
	КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-27 (#4405)
	
	Если МатериалыЗаказчика.Количество() = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
	КонецЕсли;
	
	РаздельныйУчетНДСДо2014Года = УчетнаяПолитика.РаздельныйУчетНДСДо2014Года(Организация, Дата);
	
	Если НЕ РаздельныйУчетНДСДо2014Года Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НДСвСтоимостиТоваров");
	КонецЕсли; 

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-08-02 (#4214)
	ПрослеживаемыйТовар = Материалы.НайтиСтроки(Новый Структура("ПрослеживаемыйТовар", Истина));
	ЕстьПрослеживаемыйТовар = ПрослеживаемыйТовар.Количество() <> 0;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-27 (#4405)
	ТребуетсяУчетПрослеживаемости = (ВидОперации = Перечисления.ВидыОперацийРасходМатериалов.ИспользованиеМатериалов Или 
		(ВидОперации = Перечисления.ВидыОперацийРасходМатериалов.ПередачаСотруднику
		И СпособУчетаМатериаловПоСотруднику = Перечисления.СпособыУчетаМатериаловПоСотрудникам.Расход))
		И (Не СчетЗатрат = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.СтроительствоОбъектовОсновныхСредств")
		Или СчетаУчетаЗатратВТаблице = Истина);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-27 (#4405)
	
	//НуженУчетПрослеживаемости = ВидОперации = Перечисления.ВидыОперацийРасходМатериалов.ИспользованиеМатериалов Или 
	//	(ВидОперации = Перечисления.ВидыОперацийРасходМатериалов.ПередачаСотруднику
	//	И СпособУчетаМатериаловПоСотруднику = Перечисления.СпособыУчетаМатериаловПоСотрудникам.Расход);
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-27 (#4405)
	//Если ЕстьПрослеживаемыйТовар И Не ЗначениеЗаполнено(КодОперацииПрослеживаемости) Тогда
	Если ЕстьПрослеживаемыйТовар И Не ЗначениеЗаполнено(КодОперацииПрослеживаемости)
		И ТребуетсяУчетПрослеживаемости Тогда
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-27 (#4405)
		//И НуженУчетПрослеживаемости Тогда
		ТекстОшибки = НСтр("ru='Не выбрана причина списания в прослеживаемости'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "НадписьКодОперации", , Отказ);
	КонецЕсли;
	
	Для Каждого Строка Из Материалы Цикл
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-27 (#4405)
		//Если Строка.ПрослеживаемыйТовар И Не ЗначениеЗаполнено(Строка.СтранаПроисхождения) Тогда
		Если Строка.ПрослеживаемыйТовар И Не ЗначениеЗаполнено(Строка.СтранаПроисхождения)
			И ТребуетсяУчетПрослеживаемости Тогда
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-27 (#4405)
		//	И НуженУчетПрослеживаемости Тогда
			ИмяСписка = НСтр("ru = 'Материалы'");
			Префикс = "Материалы[" + Формат(Строка.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Колонка", "Заполнение", НСтр("ru = 'Страна происхождения'"), Строка.НомерСтроки, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, ЭтотОбъект, Префикс + "СтранаПроисхождения", "Объект", Отказ);
		КонецЕсли;
	КонецЦикла;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-08-02 (#4214) 
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА

	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ТребованиеНакладная.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ

	// Таблица списанных материалов
	ТаблицаСписанныеМатериалы = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(
		ПараметрыПроведения.ТаблицаМатериалы, ПараметрыПроведения.МатериалыРеквизиты, Отказ);

	// Таблица списанных материалов заказчика
	ТаблицаСписанныеМатериалыЗаказчика = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(
		ПараметрыПроведения.ТаблицаМатериалыЗаказчика, ПараметрыПроведения.МатериалыЗаказчикаРеквизиты, Отказ);

	// Структура таблиц для отражения в налоговом учете УСН
	СтруктураТаблицУСН = Новый Структура("ТаблицаТМЦ", ТаблицаСписанныеМатериалы);
	
	// Учет доходов и расходов ИП
	ТаблицыМатериаловПродукцииИП = Документы.ТребованиеНакладная.ПодготовитьТаблицыМатериаловПродукцииИП(
		ТаблицаСписанныеМатериалы, ПараметрыПроведения.ИПРеквизиты);
	
	ТаблицыСписанияМПЗИП = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицыСписанияМПЗ(
		ТаблицыМатериаловПродукцииИП.ТаблицаМатериалов, ПараметрыПроведения.ИПРеквизиты, Отказ);
	
	ТаблицаПоступлениеПродукцииИП = УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуПоступлениеПродукции(
		ТаблицыМатериаловПродукцииИП.ПолученоПродукции, ПараметрыПроведения.ИПРеквизиты);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ

	// Списание материалов
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(
		ТаблицаСписанныеМатериалы, ПараметрыПроведения.МатериалыРеквизиты, Движения, Отказ);
	УчетТоваров.СформироватьДвиженияСписаниеТоваров(
		ТаблицаСписанныеМатериалыЗаказчика, ПараметрыПроведения.МатериалыЗаказчикаРеквизиты, Движения, Отказ);
		
	НалоговыйУчетУСН.СформироватьДвиженияУСН(ЭтотОбъект, СтруктураТаблицУСН);
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-27 (#4405)
	УчетМатериаловВЭксплуатации.СформироватьДвиженияПередачаМатериаловСотруднику(
		ПараметрыПроведения.ПередачаМатериаловСотрудникуТаблица,
		ТаблицаСписанныеМатериалы,
		ПараметрыПроведения.ПередачаМатериаловСотрудникуРеквизиты,
		Движения, Отказ);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-27 (#4405)
	
	// Учет НДС
	УчетНДСБП.СформироватьДвиженияСписаниеТоваровНаРасходы(
		ПараметрыПроведения.НДСМатериалы, ТаблицаСписанныеМатериалы, ПараметрыПроведения.НДСРеквизиты, Движения, Отказ);
		
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-25 (#4405)
	// Учет прослеживаемых товаров
	ТаблицыПрослеживаемости = ПодготовитьТаблицыДляПереносаРНПТНаОС(
		ПараметрыПроведения.ПрослеживаемыеТовары,
		ПараметрыПроведения.МатериалыРеквизиты,
		ПараметрыПроведения.ПрослеживаемыеОперации);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-25 (#4405)
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-11-08 (#4446)
	СписокКодовОпераций = ок_ОбщегоНазначения.ПолучитьЗначениеУниверсальнойНастройки("Прослеживаемость", "Коды операций с прослеживаемыми товарами", Неопределено, "СписокЗначений");
	Если СписокКодовОпераций.НайтиПоЗначению(КодОперацииПрослеживаемости) <> Неопределено Тогда
		ТаблицыПрослеживаемости.ПрослеживаемыеОперации = Неопределено;
	КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-11-08 (#4446)
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-08-02 (#4214)
	ПрослеживаемыеОперации = ПрослеживаемостьБП.ПодготовитьТаблицуПоПрослеживаемымОперациям(
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-25 (#4405)
		//ПараметрыПроведения.ПрослеживаемыеОперации, ТаблицаСписанныеМатериалы);
		ТаблицыПрослеживаемости.ПрослеживаемыеОперации, ТаблицаСписанныеМатериалы);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-25 (#4405)
	
	ПрослеживаемостьБП.СформироватьДвиженияРеализацияТоваров(
		ПараметрыПроведения.ПрослеживаемыеТовары,
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-25 (#4405)
		//ПрослеживаемыеОперации,
		ТаблицыПрослеживаемости.ПрослеживаемыеОперации,
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-25 (#4405)
		ПараметрыПроведения.МатериалыРеквизиты,
		Движения);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-08-02 (#4214) 
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-25 (#4405)
	ПрослеживаемостьБП.СформироватьДвиженияПоступлениеОС(
		ТаблицыПрослеживаемости.ПрослеживаемыеОС,
		Неопределено,
		Неопределено,
		ПараметрыПроведения.МатериалыРеквизиты,
		Движения);
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-25 (#4405)
	
	// Учет доходов и расходов ИП
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияСписаниеМПЗ(
		ТаблицыСписанияМПЗИП, ПараметрыПроведения.ИПРеквизиты, Движения, Отказ);
		
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияПоступлениеПродукции(
		ТаблицаПоступлениеПродукцииИП, ТаблицыСписанияМПЗИП.СтоимостьПродукции, 
		ПараметрыПроведения.ИПРеквизиты, Движения, Отказ);
		
	// Регистрация в последовательности
	РаботаСПоследовательностями.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект, Отказ, , ТаблицаСписанныеМатериалы);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();
	
	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если УчетнаяПолитика.СпособОценкиМПЗ(Организация, Дата) <> Перечисления.СпособыОценки.ФИФО 
		И НЕ ПолучитьФункциональнуюОпцию("ОсуществляетсяРеализацияТоваровУслугКомитентов")
		И Материалы.Количество() > 0 Тогда
		
		Материалы.ЗагрузитьКолонку(Новый Массив(Материалы.Количество()), "ДокументОприходования");
		
	КонецЕсли;
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-27 (#4405)
	Если Не ЗначениеЗаполнено(ВидОперации) Тогда
		ВидОперации = Перечисления.ВидыОперацийРасходМатериалов.ИспользованиеМатериалов;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СпособУчетаМатериаловПоСотруднику) Тогда
		СпособУчетаМатериаловПоСотруднику = Перечисления.СпособыУчетаМатериаловПоСотрудникам.Расход;
	КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-27 (#4405)
	
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли; 
	
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-08-02 (#4214) 
	Для каждого СтрокаТабличнойЧасти Из ЭтотОбъект.Материалы Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ИдентификаторСтроки) Тогда
			СтрокаТабличнойЧасти.ИдентификаторСтроки = Новый УникальныйИдентификатор;
		КонецЕсли; 
	КонецЦикла;

	ПрослеживаемыйТовар = Материалы.НайтиСтроки(Новый Структура("ПрослеживаемыйТовар", Истина));
	ЕстьПрослеживаемыйТовар = ПрослеживаемыйТовар.Количество() <> 0;
	
	//Если ЕстьПрослеживаемыйТовар И (ВидОперации = Перечисления.ВидыОперацийРасходМатериалов.ИспользованиеМатериалов Или 
	//	(ВидОперации = Перечисления.ВидыОперацийРасходМатериалов.ПередачаСотруднику
	//	И СпособУчетаМатериаловПоСотруднику = Перечисления.СпособыУчетаМатериаловПоСотрудникам.Расход)) Тогда
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-27 (#4405)
	//Если ЕстьПрослеживаемыйТовар Тогда
	Если ЕстьПрослеживаемыйТовар И (ВидОперации = Перечисления.ВидыОперацийРасходМатериалов.ИспользованиеМатериалов Или 
		(ВидОперации = Перечисления.ВидыОперацийРасходМатериалов.ПередачаСотруднику
		И СпособУчетаМатериаловПоСотруднику = Перечисления.СпособыУчетаМатериаловПоСотрудникам.Расход)) Тогда
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-27 (#4405)
		Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			ПрослеживаемостьБП.ПодобратьРНПТ(ЭтотОбъект, Отказ, "Материалы");
			Для Каждого Строка Из ПрослеживаемыйТовар Цикл
				Строка.НомерГТД = Неопределено;
			КонецЦикла;
		КонецЕсли;
	Иначе
		СведенияПрослеживаемости.Очистить();
	КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-08-02 (#4214) 
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Проверка заполнения

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);
		
		мДокументОснование 		 = Основание;
		ПодразделениеОрганизации = Основание.ПодразделениеОрганизации;
		Если Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку Тогда
			Контрагент = Основание.Контрагент;
			ИмяТаблицы	= "МатериалыЗаказчика";
		Иначе
			ИмяТаблицы	= "Материалы";
		КонецЕсли;
		
		ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
		
		Для Каждого ТекСтрокаТовары Из Основание.Товары Цикл
			
			СтрокаТабличнойЧасти                  = ЭтотОбъект[ИмяТаблицы].Добавить();
			СтрокаТабличнойЧасти.Номенклатура     = ТекСтрокаТовары.Номенклатура;
			СтрокаТабличнойЧасти.Количество       = ТекСтрокаТовары.Количество;
			СтрокаТабличнойЧасти.ЕдиницаИзмерения = ТекСтрокаТовары.ЕдиницаИзмерения;
			СтрокаТабличнойЧасти.КоличествоМест   = ТекСтрокаТовары.КоличествоМест;
			СтрокаТабличнойЧасти.Коэффициент      = ТекСтрокаТовары.Коэффициент;
			
			Если ИмяТаблицы	= "Материалы" Тогда
				СтрокаТабличнойЧасти.ОтражениеВУСН = Перечисления.ОтражениеВУСН.Принимаются;
			КонецЕсли;
			
			// BIT AMerkulov 17-08-2015 ++
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2018-12-24 (#3048)				
			//Если ЗначениеЗаполнено(ТекСтрокаТовары.Период) Тогда
				//СтрокаТабличнойЧасти.Период 			= ТекСтрокаТовары.Период;
				//СтрокаТабличнойЧасти.ЦФО 			= ТекСтрокаТовары.ЦФО;
				//СтрокаТабличнойЧасти.СтатьяОборотов 	= ТекСтрокаТовары.СтатьяОборотов;
				//СтрокаТабличнойЧасти.Объект 			= ТекСтрокаТовары.Объект;
				//Заменено на:
			Если ЗначениеЗаполнено(ТекСтрокаТовары.ок_Период) Тогда
				СтрокаТабличнойЧасти.Период			= ТекСтрокаТовары.ок_Период;
				СтрокаТабличнойЧасти.ЦФО 			= ТекСтрокаТовары.ок_ЦФО;
				СтрокаТабличнойЧасти.СтатьяОборотов = ТекСтрокаТовары.ок_СтатьяОборотов;
				СтрокаТабличнойЧасти.Объект 		= ТекСтрокаТовары.ок_Аналитика_2;
				//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2018-12-24 (#3048)
				
				Если СтрокаТабличнойЧасти.НомерСтроки = 1 И ЗначениеЗаполнено(СтрокаТабличнойЧасти.Период) Тогда
					СчетЗатрат = ПланыСчетов.Хозрасчетный.НайтиПоКоду("20.01");	
					
					// Статья (Субконто2)
					Запрос = Новый Запрос;	
					Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
					|	бит_СтатьиОборотов_СтатьиРегл.СтатьяОборотов,
					|	бит_СтатьиОборотов_СтатьиРегл.СтатьяРегл
					|ИЗ
					|	РегистрСведений.бит_СтатьиОборотов_СтатьиРегл КАК бит_СтатьиОборотов_СтатьиРегл
					|ГДЕ
					|	бит_СтатьиОборотов_СтатьиРегл.СтатьяРегл ССЫЛКА Справочник.СтатьиЗатрат 
					| И бит_СтатьиОборотов_СтатьиРегл.СтатьяОборотов = &Статья";					   
					Запрос.УстановитьПараметр("Статья",СтрокаТабличнойЧасти.СтатьяОборотов);
					ТаблицаСтатейЗатрат = Запрос.Выполнить().Выгрузить();	
					Если ТаблицаСтатейЗатрат.Количество() Тогда
						Если ТаблицаСтатейЗатрат.Количество() > 1 Тогда
							Сообщить("Найдено более одной статьи затрат по соответствию с указанной статьей оборотов!");	
						КонецЕсли;
						
						Субконто2 = ТаблицаСтатейЗатрат[0].СтатьяРегл;
					КонецЕсли;	
					
					//ЦФО
					Субконто3 = СтрокаТабличнойЧасти.ЦФО;
				КонецЕсли;		
			КонецЕсли;		
			// BIT AMerkulov 17-08-2015 --			
			
		КонецЦикла;
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);
		
		ПодразделениеОрганизации = Основание.ПодразделениеОрганизации;
		
		СписокНоменклатуры = Основание.Товары.ВыгрузитьКолонку("Номенклатура");
		ЕдиницыИзмерения = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(СписокНоменклатуры, "ЕдиницаИзмерения");
		Для Каждого СтрокаОснования Из Основание.Товары Цикл
			
			НоваяСтрока                     = Материалы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОснования, "Номенклатура, Количество, НомерГТД, СтранаПроисхождения");
			НоваяСтрока.ЕдиницаИзмерения    = ЕдиницыИзмерения[СтрокаОснования.Номенклатура];
			НоваяСтрока.Коэффициент         = 1;
			НоваяСтрока.ОтражениеВУСН       = Перечисления.ОтражениеВУСН.Принимаются;
			
		КонецЦикла;
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетПроизводстваЗаСмену") Тогда
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

		СчетаУчетаЗатратВТаблице = Истина;
		
		// Подготовим исходные данные для заполнения табличной части
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос = Новый Запрос();
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Параметры.Вставить("Основание", Основание);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК Счет
		|ПОМЕСТИТЬ СчетаПроизводствоИзДавальческогоСырья
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	Хозрасчетный.Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПроизводствоИзДавальческогоСырья))
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Счет
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА СчетаПроизводствоИзДавальческогоСырья.Счет ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ПроизводствоИзМатериаловЗаказчика,
		|	ОтчетПроизводстваЗаСменуПродукция.НомерСтроки КАК НомерСтрокиВыпуск,
		|	ОтчетПроизводстваЗаСменуПродукция.Спецификация КАК Спецификация,
		|	ОтчетПроизводстваЗаСменуПродукция.Количество КАК КоличествоПродукции,
		|	ОтчетПроизводстваЗаСменуПродукция.Ссылка.ПодразделениеЗатрат КАК ПодразделениеЗатрат,
		|	ОтчетПроизводстваЗаСменуПродукция.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
		|	ОтчетПроизводстваЗаСменуПродукция.Ссылка.СчетЗатрат КАК СчетЗатрат
		|ПОМЕСТИТЬ Выпуск
		|ИЗ
		|	Документ.ОтчетПроизводстваЗаСмену.Продукция КАК ОтчетПроизводстваЗаСменуПродукция
		|		ЛЕВОЕ СОЕДИНЕНИЕ СчетаПроизводствоИзДавальческогоСырья КАК СчетаПроизводствоИзДавальческогоСырья
		|		ПО ОтчетПроизводстваЗаСменуПродукция.Счет = СчетаПроизводствоИзДавальческогоСырья.Счет
		|ГДЕ
		|	ОтчетПроизводстваЗаСменуПродукция.Ссылка = &Основание
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЛОЖЬ,
		|	ОтчетПроизводстваЗаСменуУслуги.НомерСтроки,
		|	ОтчетПроизводстваЗаСменуУслуги.Спецификация,
		|	ОтчетПроизводстваЗаСменуУслуги.Количество,
		|	ОтчетПроизводстваЗаСменуУслуги.Ссылка.ПодразделениеЗатрат,
		|	ОтчетПроизводстваЗаСменуУслуги.НоменклатурнаяГруппа,
		|	ОтчетПроизводстваЗаСменуУслуги.Ссылка.СчетЗатрат
		|ИЗ
		|	Документ.ОтчетПроизводстваЗаСмену.Услуги КАК ОтчетПроизводстваЗаСменуУслуги
		|ГДЕ
		|	ОтчетПроизводстваЗаСменуУслуги.Ссылка = &Основание
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Спецификация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ СчетаПроизводствоИзДавальческогоСырья";
		
		Запрос.Выполнить();
		
		ЗаполнитьМатериалыПоДаннымОВыпуске(МенеджерВременныхТаблиц);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.АктОбОказанииПроизводственныхУслуг") Тогда
		
		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);

		СчетаУчетаЗатратВТаблице = Истина;
		
		// Подготовим исходные данные для заполнения табличной части
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос = Новый Запрос();
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Параметры.Вставить("Основание", Основание);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛОЖЬ КАК ПроизводствоИзМатериаловЗаказчика,
		|	АктОбОказанииПроизводственныхУслугУслуги.НомерСтроки КАК НомерСтрокиВыпуск,
		|	АктОбОказанииПроизводственныхУслугУслуги.Спецификация КАК Спецификация,
		|	АктОбОказанииПроизводственныхУслугУслуги.Количество КАК КоличествоПродукции,
		|	АктОбОказанииПроизводственныхУслугУслуги.Ссылка.ПодразделениеЗатрат КАК ПодразделениеЗатрат,
		|	АктОбОказанииПроизводственныхУслугУслуги.Ссылка.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
		|	АктОбОказанииПроизводственныхУслугУслуги.Ссылка.СчетЗатрат КАК СчетЗатрат
		|ПОМЕСТИТЬ Выпуск
		|ИЗ
		|	Документ.АктОбОказанииПроизводственныхУслуг.Услуги КАК АктОбОказанииПроизводственныхУслугУслуги
		|ГДЕ
		|	АктОбОказанииПроизводственныхУслугУслуги.Ссылка = &Основание
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Спецификация";
		Запрос.Выполнить();
		
		ЗаполнитьМатериалыПоДаннымОВыпуске(МенеджерВременныхТаблиц);
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.РеализацияУслугПоПереработке") Тогда
		// Заполнение шапки
		Комментарий        = Основание.Комментарий;
		Контрагент         = Основание.Контрагент;
		Организация        = Основание.Организация;
		мДокументОснование = Основание;
		ПодразделениеОрганизации = Основание.ПодразделениеОрганизации;
		Для Каждого ТекСтрокаМатериалыЗаказчика ИЗ Основание.МатериалыЗаказчика Цикл
			НоваяСтрока              = МатериалыЗаказчика.Добавить();
			НоваяСтрока.Количество   = ТекСтрокаМатериалыЗаказчика.Количество;
			НоваяСтрока.Номенклатура = ТекСтрокаМатериалыЗаказчика.Номенклатура;
			НоваяСтрока.СчетПередачи = ТекСтрокаМатериалыЗаказчика.СчетУчета;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		
		ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);
		
		Склад                    = Основание.СкладПолучатель;
		ПодразделениеОрганизации = Основание.ПодразделениеПолучатель;
		
		Для Каждого СтрокаОснования Из Основание.Товары Цикл
			
			НоваяСтрока = Материалы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОснования, "Номенклатура, КоличествоМест, ЕдиницаИзмерения, Коэффициент, Количество");
			НоваяСтрока.ОтражениеВУСН = Перечисления.ОтражениеВУСН.Принимаются;
			
		КонецЦикла;
		
		// Не поддерживается перемещение материалов, принятых в переработку
		
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;

	НДСвСтоимостиТоваров = Перечисления.ДействиеНДСВСтоимостиТоваров.НеИзменять;
	ДляСписанияНДСИспользоватьСчетИАналитикуУчетаЗатрат = Ложь;
	Ответственный = Пользователи.ТекущийПользователь();

КонецПроцедуры

Процедура ЗаполнитьМатериалыПоДаннымОВыпуске(МенеджерВременныхТаблиц)
	
	// Получим данные о сырье для заполнения табличной части
	// Исходные данные (таблица Выпуск) должны быть помещены в МенеджерВременныхТаблиц до выполнения процедуры
	ЭлементыТекстаЗапроса = Новый Массив;
	// Получаем данные о расходе сырья
	ЭлементыТекстаЗапроса.Добавить(УправлениеПроизводством.ТекстЗапросаВременнаяТаблицаЗатратыСырья());
	
	// Преобразуем в формат получателя
	ЭлементыТекстаЗапроса.Добавить(
		"ВЫБРАТЬ
		|	ЗатратыСырья.ПроизводствоИзМатериаловЗаказчика КАК ПроизводствоИзМатериаловЗаказчика,
		|	МИНИМУМ(ЗатратыСырья.НомерСтрокиВыпуск) КАК НомерСтрокиВыпуск,
		|	МАКСИМУМ(ЗатратыСырья.НомерСтрокиСпецификации) КАК НомерСтрокиСпецификации,
		|	ЗатратыСырья.СчетЗатрат КАК СчетЗатрат,
		|	ЗатратыСырья.СчетЗатрат.Код КАК СчетЗатратПредставление,
		|	ЗатратыСырья.ПодразделениеЗатрат КАК ПодразделениеЗатрат,
		|	ЗатратыСырья.ПодразделениеЗатрат.Наименование КАК ПодразделениеЗатратПредставление,
		|	ЗатратыСырья.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
		|	ЗатратыСырья.НоменклатурнаяГруппа.Наименование КАК НоменклатурнаяГруппаПредставление,
		|	ЗатратыСырья.Номенклатура КАК Номенклатура,
		|	ЗатратыСырья.Номенклатура.Наименование КАК НоменклатураПредставление,
		|	СУММА(ЗатратыСырья.Количество) КАК Количество,
		|	ЗатратыСырья.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	1 КАК Коэффициент,
		|	ЗНАЧЕНИЕ(Перечисление.ОтражениеВУСН.Принимаются) КАК ОтражениеВУСН,
		|	ЗатратыСырья.СтатьяЗатрат КАК СтатьяЗатрат
		|ИЗ
		|	ЗатратыСырья КАК ЗатратыСырья
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗатратыСырья.ПроизводствоИзМатериаловЗаказчика,
		|	ЗатратыСырья.Номенклатура,
		|	ЗатратыСырья.Номенклатура.Наименование,
		|	ЗатратыСырья.НоменклатурнаяГруппа,
		|	ЗатратыСырья.НоменклатурнаяГруппа.Наименование,
		|	ЗатратыСырья.СчетЗатрат,
		|	ЗатратыСырья.СчетЗатрат.Код,
		|	ЗатратыСырья.ПодразделениеЗатрат,
		|	ЗатратыСырья.ПодразделениеЗатрат.Наименование,
		|	ЗатратыСырья.ЕдиницаИзмерения,
		|	ЗатратыСырья.СтатьяЗатрат
		|
		|УПОРЯДОЧИТЬ ПО
		|	СчетЗатратПредставление,
		|	ПодразделениеЗатратПредставление,
		|	НоменклатурнаяГруппаПредставление,
		|	НомерСтрокиСпецификации,
		|	НоменклатураПредставление");
	
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = СтрСоединить(ЭлементыТекстаЗапроса, ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ПроизводствоИзМатериаловЗаказчика Тогда
			НоваяСтрока = МатериалыЗаказчика.Добавить();
		Иначе
			НоваяСтрока = Материалы.Добавить();
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
КонецПроцедуры

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-10-25 (#4405)
Функция ПодготовитьТаблицыДляПереносаРНПТНаОС(ПрослеживаемыеТовары, Реквизиты, ПрослеживаемыеОперации)
	
	ТаблицаПрослеживаемыеОС       = Неопределено;
	ТаблицаОперации               = Неопределено;

	СтруктураТаблиц = Новый Структура();
	СтруктураТаблиц.Вставить("ПрослеживаемыеОС",       ТаблицаПрослеживаемыеОС);
	СтруктураТаблиц.Вставить("ПрослеживаемыеОперации", ТаблицаОперации);
	
	Если ПрослеживаемыеТовары = Неопределено Тогда
		Возврат СтруктураТаблиц;
	КонецЕсли;
	
	СтрокаРеквизитов = Реквизиты[0];
	Если Не СтрокаРеквизитов.СчетаУчетаЗатратВТаблице И 
		СтрокаРеквизитов.СчетЗатрат = ПланыСчетов.Хозрасчетный.СтроительствоОбъектовОсновныхСредств Тогда
		ТаблицаПрослеживаемыеОС = ПрослеживаемыеТовары.Скопировать();
		ТаблицаПрослеживаемыеОС.ЗаполнитьЗначения(СтрокаРеквизитов.Субконто1, "ОсновноеСредство");
	Иначе
		ТаблицаОперации = ПрослеживаемыеОперации;
	КонецЕсли;
	
	СтруктураТаблиц.ПрослеживаемыеОС       = ТаблицаПрослеживаемыеОС;
	СтруктураТаблиц.ПрослеживаемыеОперации = ТаблицаОперации;
	
	Возврат СтруктураТаблиц;

КонецФункции
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-10-25 (#4405)

#КонецЕсли
