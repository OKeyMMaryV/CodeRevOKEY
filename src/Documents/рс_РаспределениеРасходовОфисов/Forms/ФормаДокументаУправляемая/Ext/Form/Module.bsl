////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит текущие значения реквизитов формы. Клиент.
&НаКлиенте 
Перем мКэшРеквизитовФормы;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура устнавливает заголовок формы документа.
//
// Параметры:
//  Нет.
//
&НаКлиенте 
Процедура УстановитьЗаголовокФормыДокумента()
	
	СтруктураЗаголовка = Новый Структура;
	СтруктураЗаголовка.Вставить("ПредставлениеОбъекта", фКэшЗначений.ПредставлениеОбъекта);
	СтруктураЗаголовка.Вставить("СтрокаВидаОперации"  , Строка(""));
	СтруктураЗаголовка.Вставить("ЭтоНовый"			  , Параметры.Ключ.Пустая());
	СтруктураЗаголовка.Вставить("ДокументПроведен"	  , Объект.Проведен);
	
	бит_РаботаСДиалогамиКлиент.УстановитьЗаголовокФормыДокумента(ЭтаФорма
																,СтруктураЗаголовка);
	
КонецПроцедуры // УстановитьЗаголовокФормыДокумента()

////////////////////////////////////////////////////////////////////////////////
// РАБОТА С КЭШЕМ РЕКВИЗИТОВ ФОРМЫ

// Процедура заполняет кэш реквизитов формы данными объекта.
//
// Параметры:
//  Нет.
//
&НаКлиенте 
Процедура ЗаполнитьТекущиеЗначенияРеквизитовФормы()
	
	Для Каждого КлючИЗначение Из мКэшРеквизитовФормы Цикл
		мКэшРеквизитовФормы[КлючИЗначение.Ключ] = Объект[КлючИЗначение.Ключ];
	КонецЦикла; 
	
КонецПроцедуры // ЗаполнитьТекущиеЗначенияРеквизитовФормы()

// Процедура добавляет в кэш реквизитов текущее значение заданного реквизита.
//
// Параметры:
// 	ИмяРеквизита - Строка.
//
&НаКлиенте
Процедура ДобавитьВКэш(ИмяРеквизита)
	
	мКэшРеквизитовФормы[ИмяРеквизита] = Объект[ИмяРеквизита];	
	
КонецПроцедуры // ДобавитьВКэш()

// Процедура извлекает из кэша и присваивает объекту значение заданного реквизита.
//
// Параметры:
// 	ИмяРеквизита - Строка.
//
&НаКлиенте
Процедура ИзвлечьИзКэша(ИмяРеквизита)
	
	Объект[ИмяРеквизита] = мКэшРеквизитовФормы[ИмяРеквизита];
	
КонецПроцедуры // ИзвлечьИзКэша()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриОткрытии" формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтоНовый = ?(Параметры.Ключ.Пустая(), Истина, Ложь);
	
	Если ЭтоНовый Тогда
		// Заполнить реквизиты значениями по умолчанию.
		ЗаполнитьШапкуДокумента();	
	КонецЕсли;
	
	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен).
	УстановитьЗаголовокФормыДокумента();
	
	// Зададим имена реквизитов, подлежащих кешированию.
	мКэшРеквизитовФормы = Новый Структура;
	мКэшРеквизитовФормы.Вставить("Организация");
	
	// Запомним текущие значения реквизитов формы.
	ЗаполнитьТекущиеЗначенияРеквизитовФормы();
	
	ПриОткрытииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьШапкуДокумента()
	рс_ОбщийМодуль.ЗаполнитьШапкуДокумента(Объект, Объект.Ссылка.Метаданные(), бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"));	
КонецПроцедуры

&НаСервере
Функция ПриОткрытииНаСервере()
	
	ЭтоНовый = ?(Параметры.Ключ.Пустая(), Истина, Ложь);
	
	Если ЭтоНовый Тогда
		Объект.Дата = КонецДня(Объект.Дата);
		
		Объект.Счет 		= рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.СчетУчетаРасходовОфисов);
		Объект.ФункцияЦФО 	= рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.ФункцияПоУмолчаниюДляРасходовОфисов);
		Объект.Объект	 	= рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.ОбъектДляРаспределенияРасходовОфисовНаТЦ);
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецФункции

// Процедура - обработчик события "ПослеЗаписи" формы.
//
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Вывести в заголовке формы вид операции и статус документа (новый, не проведен, проведен).
	УстановитьЗаголовокФормыДокумента();
	Модифицированность = Ложь;
	
	ОповеститьОЗаписиНового(ЭтаФорма.Объект);
	
КонецПроцедуры // ПослеЗаписи()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД ФОРМЫ     


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЕРВЕРНЫЕ ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПриЧтенииНаСервере" формы.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьКэшЗначений();
	УстановитьНастройкиДоступностиЭлементов();
			
КонецПроцедуры // ПриЧтенииНаСервере()

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//1С-ИжТиСи, Кондратьев, 03.2020, обновление (
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	//1С-ИжТиСи, Кондратьев, 03.2020, обновление )

	//Стандартные действия при создании на сервере
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	// Вызов механизма защиты
	//бит_ЛицензированиеБФCервер.ПроверитьВозможностьРаботы(ЭтаФорма, МетаданныеОбъекта.ПолноеИмя(), Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Открытие нового 
   	Если Параметры.Ключ.Пустая() Тогда
		
		ЗаполнитьКэшЗначений();
		//СтруктураНастройки = РегистрыСведений.бит_вго_НастройкиПроведенияСверкиВГО.ПолучитьПоследнее(Объект.Дата, Новый Структура("Настройка", ПланыВидовХарактеристик.бит_вго_ВидыНастроекСверкиВГО.КонтролироватьДопустимоеРасхождение));
		//Объект.КонтролироватьДопустимоеРасхождение    = СтруктураНастройки.Значение;
		
	КонецЕсли;

КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события "ПередЗаписьюНаСервере" формы.
//
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Если Не Отказ Тогда		
			//ТекущийОбъект.ДополнительныеСвойства.Вставить("СуммаАбсолютногоРасхождения"	  , Объект.СуммаАбсолютногоРасхождения);
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписьюНаСервере()

// Процедура - обработчик события "ПослеЗаписиНаСервере" формы.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьНастройкиДоступностиЭлементов();
	
КонецПроцедуры // ПослеЗаписиНаСервере()

////////////////////////////////////////////////////////////////////////////////
// СЕРВЕРНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура заполняет кэш значений, необходимый при работе на клиенте.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ЗаполнитьКэшЗначений()

	фКэшЗначений = Новый Структура;
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();

	фКэшЗначений.Вставить("ПредставлениеОбъекта", МетаданныеОбъекта.ПредставлениеОбъекта);
	фКэшЗначений.Вставить("ИмяТипаОбъекта", "ДокументОбъект." + МетаданныеОбъекта.Имя);
 	
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура устанавлиант видимость доступность элементов формы
//
// Параметры:
//  Нет
//
&НаСервере
Процедура УстановитьВидимость()
	
	//ЭтоРегистрБюдж = Объект.РегистрБухгалтерии.ИмяОбъекта = "бит_Бюджетирование";
	//Элементы.Сценарий.Видимость = ЭтоРегистрБюдж;
	
	Элементы.Объект.Видимость = (Объект.ВидОперации = Перечисления.рс_ВидыОперацийРаспределениеРасходовОфисов.НаТЦ);
                 	
КонецПроцедуры // УстановитьВидимостьДоступностьПоРегБух()

// Процедура применяет настройки доступности и видимости для элементов формы.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьНастройкиДоступностиЭлементов() Экспорт
	
	// Получение таблицы настроек доступности элементов управления.
	ТаблицаНастроекДоступности = бит_ОбщегоНазначения.ПолучитьНастройкиДоступностиЭлементовУправления(Объект, Истина);
	
	// Фильтр таблицы настроек по статусу.
	ДокументЗаявка 			  = ДанныеФормыВЗначение(Объект, Тип(фКэшЗначений.ИмяТипаОбъекта));
	ТекущийСтатус			  = Неопределено;
	ТаблицаАктуальныхНастроек = бит_ОбщегоНазначения.ПолучитьАктуальныеНастройки(ТаблицаНастроекДоступности
																				,ТекущийСтатус);
	
	// Структура параметров для проверки произвольного условия.
	ПараметрыУсловия = Новый Структура;
	ПараметрыУсловия.Вставить("ТекущийОбъект", Объект);
	//ПараметрыУсловия.Вставить("Статус"		 , ТекущийСтатус);
	
	// Применяем настройки.
	бит_ОбщегоНазначения.УстановитьДоступностьЭлементовУправленияПоНастройкам(ЭтаФорма
																			 ,ТаблицаАктуальныхНастроек
																			 ,ПараметрыУсловия);
КонецПроцедуры // УстановитьНастройкиДоступностиЭлементов()

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//1С-ИжТиСи, Кондратьев, 03.2020, обновление )