﻿// Модуль описывает технологические особенности размещения данных в декларации по налогу на прибыль
// (отчета БРО РегламентированныйОтчетПрибыль)

#Область ПрограммныйИнтерфейс

#Область СтруктураКонтейнера

// Определяет версию контейнера БРО, содержащего данные декларации.
// Ранее редакции формы использовали двухуровневую структуру,
// начиная с отчетности за 2019 год - трехуровневую, где приложения к листу 02 подчинены листу 02.
// Подробнее об устройстве контейнера см. СтраницыРазделаКонтейнера
//
// Параметры:
//  ИмяРедакции - Строка - имя редакции отчета (формы БРО)
// 
// Возвращаемое значение:
//  Дата - идентификатор версии. Можно сравнивать с применением операторов < или >
//
Функция ВерсияКонтейнера(ИмяРедакции) Экспорт
	
	Если ИмяРедакции = "ФормаОтчета2013Кв4"
		Или ИмяРедакции = "ФормаОтчета2015Кв1"
		Или ИмяРедакции = "ФормаОтчета2016Кв4" Тогда
		Возврат '2016-10-01';
	КонецЕсли;
	
	Возврат '2019-10-01';
	
КонецФункции

// Конструирует техногенный номер ячейки, используемый в форме отчета,
// по данным, предусмотренным нормативным документом
//
// Параметры:
//  НомерЛиста		 - Строка - номер листа декларации, как указано в нормативном документе, например "02"
//  НомерПриложения	 - Строка - номер приложения к листу декларации, как указано в нормативном документе, например "1"
//  НомерСтроки		 - Строка - номер строки, как указано в нормативном документе, например "030"
//  НомерГрафы		 - Строка - условный номер графы (колонки), предусмотренный разработчиками БРО.
//                              Обычно основные суммовые показатели имеют условный номер "03".
//  ИмяРедакции      - Строка - имя редакции отчета (формы БРО)
// 
// Возвращаемое значение:
//  Строка - номер ячейки отчета
//
Функция НомерЯчейки(Знач НомерЛиста, Знач НомерПриложения, Знач НомерСтроки, Знач НомерГрафы, ИмяРедакции) Экспорт
	
	// Структура номера: ПРРРРРСССССГГ, где
	// П - Префикс      - традиционный префикс, символ "П"
	// Р - НомерРаздела - условный номер раздела (листа, приложения и т.п.)
	// С - НомерСтроки  - условный номер строки
	// Г - НомерГрафы   - условный номер графы (колонки)
	// В разных редакциях формы отличается внутренняя структура перечисленных элементов.
	Префикс    = "П";
	
	// НомерРаздела включает в себя номер листа и номер приложения к нему.
	// В разных редакциях формы эти номера разной длины и семантики.
	ДлинаНомераРаздела = 5;
	Если ВерсияКонтейнера(ИмяРедакции) < '2019-10-01' Тогда
		Если ИмяРедакции = "ФормаОтчета2013Кв4" Тогда
			ДлинаНомераЛиста = 3;
		Иначе
			ДлинаНомераЛиста = 4;
		КонецЕсли;
		ДлинаНомераПриложения = ДлинаНомераРаздела - ДлинаНомераЛиста;
		НомерЛиста      = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерЛиста,      ДлинаНомераЛиста);
		НомерПриложения = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерПриложения, ДлинаНомераПриложения);
		НомерРаздела    = НомерЛиста + НомерПриложения;
	Иначе
		НомерРаздела = НомерЛиста + НомерПриложения;
		НомерРаздела = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерРаздела, ДлинаНомераРаздела);
	КонецЕсли;
	
	НомерСтроки = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерСтроки, 5);
	НомерГрафы  = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НомерГрафы,  2);
	
	Возврат Префикс + НомерРаздела + НомерСтроки + НомерГрафы;
	
КонецФункции

// Конструирует имя раздела (листа, приложения к листу, раздела декларации, подраздела и т.п.), используемое в контейнере БРО
//
// Параметры:
//  НомерЛиста		 - Строка - номер листа декларации, как указано в нормативном документе, например "02"
//  НомерПриложения	 - Строка - номер приложения к листу декларации, как указано в нормативном документе, например "1"
// 
// Возвращаемое значение:
//  Строка - имя раздела
//
Функция ИмяРаздела(НомерЛиста, НомерПриложения) Экспорт
	
	ИмяПриложения = "";
	Если Не ПустаяСтрока(НомерПриложения) Тогда
		ИмяПриложения = "_" + НомерПриложения;
	Иначе
		ИмяПриложения = "";
	КонецЕсли;
	
	Возврат "Лист" + НомерЛиста + ИмяПриложения;
	
КонецФункции

// Находит в контейнере данных отчета коллекцию записей, соответствующую набору страниц заданного раздела (листа, приложения к листу и т.п.)
//
// Параметры:
//  Контейнер              - ДеревоЗначений, Структура - заполняемый контейнер, тип определяется редакцией отчета, см. ВерсияКонтейнера
//  НомерЛиста             - Строка - номер листа декларации, как указано в нормативном документе, например "02"
//  НомерПриложения        - Строка - номер приложения к листу декларации, как указано в нормативном документе, например "1"
//  ИндексКомплектаСтраниц - Число  - индекс заполняемой страницы (комплекта страниц) отчета.
//                                    Для добавления страницы см. ДобавитьСтраницу
//  ИмяРедакции            - Строка - имя редакции отчета (формы БРО)
// 
// Возвращаемое значение:
//  КоллекцияСтрокДереваЗначений, Структура - страница контейнера БРО, с которой можно работать методами области УстановкаЗначенийКонтейнера
//
Функция СтраницыРазделаКонтейнера(Контейнер, НомерЛиста, НомерПриложения, ИндексКомплектаСтраниц, ИмяРедакции) Экспорт
	
	Если ВерсияКонтейнера(ИмяРедакции) < '2019-10-01' Тогда
		// Контейнер представляет собой структуру, каждый элемент которой - именованный контейнер данных раздела.
		ИмяРазделаБРО = ИмяРаздела(НомерЛиста, НомерПриложения);
		Возврат РазделОтчета(Контейнер, ИмяРазделаБРО);
	КонецЕсли;
	
	// Контейнер представляет собой структуру, каждый элемент которой -
	// именованный контейнер данных Листа верхнего уровня (без Приложений).
	// Внутри элемента хранится дерево групп разделов, объединенных признаком налогоплательщика.
	// Каждая группа содержит контейнеры данных раздела, соответствующие Приложению к Листу.
	
	ИмяРазделаЛиста = ИмяРаздела(НомерЛиста, "");
	РазделЛиста = РазделОтчета(Контейнер, ИмяРазделаЛиста);
	
	Если РазделЛиста = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ПустаяСтрока(НомерПриложения) Тогда
		Возврат РазделЛиста;
	КонецЕсли;
	
	Если РазделЛиста.Количество() <= ИндексКомплектаСтраниц Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ГруппаРазделовПриложений = РазделЛиста[ИндексКомплектаСтраниц];
	
	Если НомерПриложения = "1" Тогда
		ИндексПриложения = 0;
	ИначеЕсли НомерПриложения = "2" Тогда
		ИндексПриложения = 1;
	ИначеЕсли НомерПриложения = "3" Тогда
		ИндексПриложения = 2;
	ИначеЕсли НомерПриложения = "4" Тогда
		ИндексПриложения = 3;
	ИначеЕсли НомерПриложения = "5" Тогда
		ИндексПриложения = 4;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ГруппаРазделовПриложений.Строки[ИндексПриложения].Строки;
	
КонецФункции

// Определяет номер служебной ячейки для хранения признака налогоплательщика.
// Нормативные документы предусматривают такое поле отчета, но не присваивают ему номер.
//
// Параметры:
//  НомерЛиста       - Строка - номер листа декларации, как указано в нормативном документе, например "02"
//  НомерПриложения  - Строка - номер приложения к листу декларации, как указано в нормативном документе, например "1"
//  ИмяРедакции      - Строка - имя редакции отчета (формы БРО)
// 
// Возвращаемое значение:
//  Строка - см. НомерЯчейки
//
Функция НомерСлужебнойЯчейкиПризнакНалогоплательщика(НомерЛиста, НомерПриложения, ИмяРедакции) Экспорт
	
	// О назначении служебного поля см. комментарий в ПередатьРассчитанныеЗначения()
	УсловныйНомерСтроки = "1";
	УсловныйНомерГрафы  = "0";
	Возврат НомерЯчейки(НомерЛиста, НомерПриложения, УсловныйНомерСтроки, УсловныйНомерГрафы, ИмяРедакции);
	
КонецФункции

// Добавляет в контейнер данных отчета страницу раздела отчета (листа, приложения и т.п.)
//
// Параметры:
//  РазделБРО   - КоллекцияСтрокДереваЗначений, Структура - результат СтраницыРазделаКонтейнера
//  ИмяРедакции - Строка - имя редакции отчета (формы БРО)
//
Процедура ДобавитьСтраницу(РазделБРО, ИмяРедакции) Экспорт
	
	НоваяСтраница = РазделБРО.Добавить();
	Образец = РазделБРО[0];
	НоваяСтраница.Данные = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(Образец.Данные);
	
	Если ВерсияКонтейнера(ИмяРедакции) >= '2019-10-01' Тогда
		ИнициализироватьДанныеМногострочныхЧастей(НоваяСтраница);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УстановкаЗначенийКонтейнера

// Помещает в контейнер (на страницу контейнера) значение показателя.
// Не следует использовать для показателей многострочных частей. Для них - УстановитьДанныеМногострочнойЧасти
//
// Параметры:
//  Страница     - СтрокаДереваЗначений, ТаблицаЗначений, ДанныеФормыКоллекция - элемент коллекции из СтраницыРазделаКонтейнера
//  НомерЯчейки  - Строка - номер заполняемого поля отчета, см. НомерЯчейки
//  Значение     - Число, Строка, Дата - устанавливаемое значение;
//                 тип определяется разработчиками БРО исходя из назначения ячейки. Обычно - Число
//
Процедура ПоместитьЗначениеПоказателяНаСтраницу(Страница, НомерЯчейки, Значение) Экспорт
	
	// показатели многострочных частей см. в УстановитьДанныеМногострочнойЧасти
	
	ПоказателиБРО = РаспаковатьПоказатели(Страница);
	Если ПоказателиБРО = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// БРО предоставляет контейнер, инициализированный номерами ячеек
	Если Не ПоказателиБРО.Свойство(НомерЯчейки) Тогда
		Возврат;
	КонецЕсли;
	
	// В ходе заполнения нельзя менять тип значения в контейнере
	ТекущееЗначение = ПоказателиБРО[НомерЯчейки];
	ДопустимыйТип   = ТипЗнч(ТекущееЗначение);
	
	Если ТипЗнч(Значение) = ДопустимыйТип Тогда
		ПоказателиБРО.Вставить(НомерЯчейки, Значение);
	Иначе
		// очистим значение
		ОписаниеТипов = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДопустимыйТип));
		ПоказателиБРО.Вставить(НомерЯчейки, ОписаниеТипов.ПривестиЗначение(Значение));
	КонецЕсли;
	
КонецПроцедуры

// Помещает в контейнер (на страницу контейнера) значения показателей многострочной части
// Для установки основных данных декларации - в ПоместитьЗначениеПоказателяНаСтраницу
//
// Параметры:
//  Страница                 - СтрокаДереваЗначений, ТаблицаЗначений, ДанныеФормыКоллекция - элемент коллекции из СтраницыРазделаКонтейнера
//  КодЭлементаФНС           - Строка - код многострочной части в соответствии с форматом представления декларации в электронном виде
//  ДанныеМногострочнойЧасти - ТаблицаЗначений - помещаемые данные. Колонки должны иметь имена и типы,
//                             предусмотренные форматом представления декларации в электронном виде
//                             (см. "коды", "признак типа, формат элемента" соответственно)
//  ИмяРедакции              - Строка - имя редакции отчета (формы БРО)
//
Процедура УстановитьДанныеМногострочнойЧасти(Страница, КодЭлементаФНС, ДанныеМногострочнойЧасти, ИмяРедакции) Экспорт
	
	КодМногострочнойЧасти = КодМногострочнойЧасти(КодЭлементаФНС);
	Если Не ЗначениеЗаполнено(КодМногострочнойЧасти) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Страница.ДанныеМногострочныхЧастей.Свойство(КодМногострочнойЧасти) Тогда
		Возврат;
	КонецЕсли;
	
	СтрокиМногострочнойЧасти = Страница.ДанныеМногострочныхЧастей[КодМногострочнойЧасти].Строки;
	
	ШаблоныПолей = ИнициализироватьСтрокиМногострочнойЧасти(СтрокиМногострочнойЧасти);
	
	Если ШаблоныПолей = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеМногострочнойЧасти) Тогда
		Возврат;
	КонецЕсли;
	
	ДлинаСлужебногоНомера = 5;
	
	КодыКолонок = Новый Соответствие;
	Для Каждого ОписаниеКолонки Из ДанныеМногострочнойЧасти.Колонки Цикл
		
		КодКолонки = КодМногострочнойЧасти + КодМножественногоЭлемента(КодЭлементаФНС, ОписаниеКолонки.Имя, ИмяРедакции);
		
		Если ПустаяСтрока(КодКолонки) Тогда
			Продолжить;
		КонецЕсли;
		
		КодыКолонок.Вставить(КодКолонки, ОписаниеКолонки.Имя);
		
	КонецЦикла;
	
	Для Каждого СтрокаСписка Из ДанныеМногострочнойЧасти Цикл
		
		ИндексСтроки = ДанныеМногострочнойЧасти.Индекс(СтрокаСписка);
		
		Если СтрокиМногострочнойЧасти.Количество() > ИндексСтроки Тогда
			
			СтрокаМногострочнойЧасти = СтрокиМногострочнойЧасти[ИндексСтроки];
			
		Иначе
			
			СтрокаМногострочнойЧасти = СтрокиМногострочнойЧасти.Добавить();
			СтрокаМногострочнойЧасти.Данные = ОбщегоНазначения.СкопироватьРекурсивно(ШаблоныПолей.ЗначенияПоУмолчанию);
			
			ИнициализироватьДанныеМногострочныхЧастей(СтрокаМногострочнойЧасти);
			
		КонецЕсли;
		
		Для Каждого ОписаниеКолонки Из КодыКолонок Цикл
			Значение = СтрокаСписка[ОписаниеКолонки.Значение];
			Если Не ШаблоныПолей.ЗначенияПоУмолчанию.Свойство(ОписаниеКолонки.Ключ) Тогда
				Продолжить;
			КонецЕсли;
			ОписаниеТипов = ШаблоныПолей.ОписанияТипов[ОписаниеКолонки.Ключ];
			СтрокаМногострочнойЧасти.Данные.Вставить(ОписаниеКолонки.Ключ, ОписаниеТипов.ПривестиЗначение(Значение));
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Включает страницу - отмечает, что страница содержит данные.
//
// Имеет два аспекта: технический и налоговый.
// 1. С технической точки зрения, показываем, используется ли конкретная страница - будет ли она представлена в составе декларации.
//    Поэтому, если есть данные для заполнения на этой странице, то нужно убедиться, что поле также заполнено.
// 2. С налоговой точки зрения, указываются особенности операций, отраженных на конкретной странице.
//    Автоматическое заполнение предполагает, что речь идет об обычных операциях - без особенностей.
//
// Параметры:
//  Страница         - СтрокаДереваЗначений, ТаблицаЗначений, ДанныеФормыКоллекция - элемент коллекции из СтраницыРазделаКонтейнера
//                     Следует передавать только фактически заполненные страницы
//  ОписаниеСтраницы - СтрокаТаблицыЗначений - см. СоставДекларации - запись, соответствующая включаемой странице
//  НомерЛиста       - Строка - номер листа декларации, как указано в нормативном документе, например "02"
//  НомерПриложения  - Строка - номер приложения к листу декларации, как указано в нормативном документе, например "1"
//  ИмяРедакции      - Строка - имя редакции отчета (формы БРО)
//
Процедура ВключитьСтраницу(Страница, НомерЛиста, НомерПриложения, ИмяРедакции) Экспорт
	
	ПоказателиБРО = РаспаковатьПоказатели(Страница);
	Если ПоказателиБРО = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВерсияКонтейнера(ИмяРедакции) < '2019-10-01' Тогда
		
		// Поле "Признак налогоплательщика" совмещает обе функции
		ПризнакНалогоплательщикаПоУмолчанию = "1";
		
	Иначе
		
		Если ПоказателиБРО.Свойство("ПризнакВключения") Тогда
			ПоказателиБРО.ПризнакВключения = "V";
		КонецЕсли;
		
		ПризнакНалогоплательщикаПоУмолчанию = "01";
		
	КонецЕсли;
	
	НомерСлужебнойЯчейки = НомерСлужебнойЯчейкиПризнакНалогоплательщика(НомерЛиста, НомерПриложения, ИмяРедакции);
		
	// Так как процедура вызывается для фактически заполненных страниц, то ранее - в ходе заполнения -
	// уже убедились, что страница пригодна для ПоместитьЗначениеПоказателяНаСтраницу()
		
	Если Не ПоказателиБРО.Свойство(НомерСлужебнойЯчейки) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПоказателиБРО[НомерСлужебнойЯчейки]) Тогда
		// Уже установлено значение
		Возврат;
	КонецЕсли;
		
	ПоместитьЗначениеПоказателяНаСтраницу(Страница, НомерСлужебнойЯчейки, ПризнакНалогоплательщикаПоУмолчанию);
	
КонецПроцедуры

#КонецОбласти

#Область ДействияПослеЗаполнения

// Выполняет действия, необходимые после автозаполнения.
// Это код БРО, однако необходим явный его вызов из переопределяемого кода прикладного решения,
// так как этот переопределяемый код в БРО является обработчиком фонового задания.
//
// Параметры:
//  Контейнер            - ДеревоЗначений, Структура - заполненный контейнер, тип определяется редакцией отчета, см. ВерсияКонтейнера
//  ТаблицаРасшифровки	 - ТаблицаЗначений - данные расшифровки. Конкретный формат определяется прикладным решением.
//                         Например, может использоваться ЗаполнениеРасшифровкаРегламентированнойОтчетности.НовыйРасшифровка
//  ПараметрыОтчета      - Структура - параметры, передаваемые БРО в РегламентированнаяОтчетностьПереопределяемый.ЗаполнитьОтчет
//  ИмяРедакции          - Строка - имя редакции отчета (формы БРО)
//
Процедура ПринятьРезультатАвтозаполнения(Контейнер, ТаблицаРасшифровки, ПараметрыОтчета, ИмяРедакции) Экспорт
	
	Если ВерсияКонтейнера(ИмяРедакции) < '2019-10-01' Тогда
		
		// В устаревших редакциях формы контейнер заполняется в том же сеансе, что и сохраняется в данных отчета.
		// Поэтому присваивается новый адрес хранилища в привязке к форме отчета.
		ПараметрыОтчета.АдресВременногоХранилищаРасшифровки = 
			ПоместитьВоВременноеХранилище(ТаблицаРасшифровки, ПараметрыОтчета.УникальныйИдентификаторФормы);
			
		Возврат;
			
	КонецЕсли;
	
	// В современных редакциях формы заполнение отчета выполняется фоновым заданием.
	// Для передачи данных из сеанса фонового задания в сеанс пользователя используются заранее подготовленные адреса хранилища.
	
	ПоместитьВоВременноеХранилище(ТаблицаРасшифровки, ПараметрыОтчета.АдресВременногоХранилищаРасшифровки);
	ПоместитьВоВременноеХранилище(Контейнер,          ПараметрыОтчета.АдресВоВременномХранилище);
	
КонецПроцедуры

#КонецОбласти

#Область КодыСписков

// Определяет служебный номер колонки многострочной части, используемый в контейнере формы отчета.
// Номер колонки включает относительный номер многострочной части и номер показателя в ней.
//
// Параметры:
//  КодТаблицыФНС	 - Строка - код таблицы (элемента типа "С") в формате представления декларации в электронном виде
//  КодЭлементаФНС	 - Строка - код элемента (колонки таблицы) в формате представления декларации в электронном виде
//  ИмяРедакции      - Строка - имя редакции отчета (формы БРО)
// 
// Возвращаемое значение:
//  Строка - семизначный номер колонки
//
Функция СлужебныйНомерКолонкиМногострочнойЧасти(КодТаблицыФНС, КодЭлементаФНС, ИмяРедакции) Экспорт
	
	КодМногострочнойЧасти = КодМногострочнойЧасти(КодТаблицыФНС);
	ОтносительныйКодМногострочнойЧасти = Прав(КодМногострочнойЧасти, 2); // Код в рамках страницы
	
	Возврат ОтносительныйКодМногострочнойЧасти + КодМножественногоЭлемента(КодТаблицыФНС, КодЭлементаФНС, ИмяРедакции);
	
КонецФункции

// Определяет служебный номер показателя многострочной части, используемый для нумерации ячеек формы отчета.
//
// Параметры:
//  КодТаблицыФНС	 - Строка - код таблицы (элемента типа "С") в формате представления декларации в электронном виде
//  КодЭлементаФНС	 - Строка - код элемента (колонки таблицы) в формате представления декларации в электронном виде
//  ИмяРедакции      - Строка - имя редакции отчета (формы БРО)
// 
// Возвращаемое значение:
//  Строка - пятизначный номер ячейки (включает условный номер строки и графы)
//
Функция КодМножественногоЭлемента(КодТаблицыФНС, КодЭлементаФНС, ИмяРедакции) Экспорт
	
	Если КодТаблицыФНС = "ОстУбытНачПерГод" Тогда
		Если КодЭлементаФНС = "Год" Тогда
			Возврат "00001";
		ИначеЕсли КодЭлементаФНС = "ОстУбыт" Тогда
			Возврат "00003";
		КонецЕсли;
	ИначеЕсли КодТаблицыФНС = "РаспрНалСубРФТип" Тогда
		Если ВерсияКонтейнера(ИмяРедакции) < '2019-10-01' Тогда
			Если КодЭлементаФНС = "ОбРасч" Тогда
				Возврат "01000";
			ИначеЕсли КодЭлементаФНС = "КППОП" Тогда
				Возврат "02001";
			ИначеЕсли КодЭлементаФНС = "ОбязУплНалОП" Тогда
				Возврат "02002";
			ИначеЕсли КодЭлементаФНС = "НаимОП" Тогда
				Возврат "02003";
			КонецЕсли;
		Иначе
			// Актуальная версия
			Если КодЭлементаФНС = "ОбРасч" Тогда
				Возврат "00300";
			ИначеЕсли КодЭлементаФНС = "КППОП" Тогда
				Возврат "00400";
			ИначеЕсли КодЭлементаФНС = "ОбязУплНалОП" Тогда
				Возврат "00500";
			ИначеЕсли КодЭлементаФНС = "НаимОП" Тогда
				Возврат "00600";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КодМногострочнойЧасти(КодЭлементаФНС)
	
	Если КодЭлементаФНС = "ОстУбытНачПерГод" Тогда
		Возврат "П00024М1";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция РаспаковатьПоказатели(Страница)
	
	Если ТипЗнч(Страница) = Тип("СтрокаДереваЗначений") Тогда
		Возврат Страница.Данные;
	КонецЕсли;
		
	// Техническая особенность БРО: показатели хранятся внутри списка значений, в котором всегда одна строка.
	ХранилищеПоказателей = Страница.Данные;
	Если ХранилищеПоказателей.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПоказателиБРО = ХранилищеПоказателей[0].Значение;
	Если ТипЗнч(ПоказателиБРО) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Возврат ПоказателиБРО;
	
КонецФункции

Функция ШаблоныСтрокМногострочнойЧасти()
	
	Шаблоны = Новый Структура;
	Шаблоны.Вставить("ОписанияТипов",       Новый Структура); // Ключ - имя колонки, Значение - ОписаниеТипов
	Шаблоны.Вставить("ЗначенияПоУмолчанию", Новый Структура); // Ключ - имя колонки, Значение - значение по умолчанию
	
	Возврат Шаблоны;
	
КонецФункции

Функция ИнициализироватьСтрокиМногострочнойЧасти(СтрокиМногострочнойЧасти)
	
	// Коллекцию необходимо инициализировать:
	// - она не должна содержать данных
	// - должна сохраниться первая строка, поставляющая типы полей
	
	Если Не ЗначениеЗаполнено(СтрокиМногострочнойЧасти) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Для НомерСтроки = 2 По СтрокиМногострочнойЧасти.Количество() Цикл
		СтрокиМногострочнойЧасти.Удалить(1);
	КонецЦикла;
	
	ИсточникПолей = СтрокиМногострочнойЧасти[0].Данные;
	Если ТипЗнч(ИсточникПолей) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Шаблоны = ШаблоныСтрокМногострочнойЧасти();
	Для Каждого ОписаниеПоля Из ИсточникПолей Цикл
		
		ДопустимыйТип = ТипЗнч(ОписаниеПоля.Значение);
		ОписаниеТипов = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДопустимыйТип));
		
		Шаблоны.ОписанияТипов.Вставить(ОписаниеПоля.Ключ, ОписаниеТипов);
		Шаблоны.ЗначенияПоУмолчанию.Вставить(ОписаниеПоля.Ключ, ОписаниеТипов.ПривестиЗначение(Неопределено));
		
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ИсточникПолей, Шаблоны.ЗначенияПоУмолчанию);
	
	Возврат Шаблоны;
	
КонецФункции

Процедура ИнициализироватьДанныеМногострочныхЧастей(ЭлементКонтейнера)
	
	// Форма зачем-то рассчитывает на инициализированное значение
	ЭлементКонтейнера.ДанныеМногострочныхЧастей = Новый Структура;
	
КонецПроцедуры

// Предоставляет коду заполнения доступ к части контейнера, соответствующей разделу отчета
Функция РазделОтчета(Контейнер, ИмяРаздела)
	
	Если Не Контейнер.Свойство(ИмяРаздела) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РазделОтчета = Контейнер[ИмяРаздела];
	
	Если ТипЗнч(РазделОтчета) = Тип("ДеревоЗначений") Тогда
		РазделОтчета = РазделОтчета.Строки;
	ИначеЕсли ТипЗнч(РазделОтчета) <> Тип("ТаблицаЗначений")
		И ТипЗнч(РазделОтчета) <> Тип("ДанныеФормыКоллекция") Тогда
		// Не умеем такие обрабатывать
		Возврат Неопределено;
	КонецЕсли;
	
	Если РазделОтчета.Количество() = 0 Тогда
		// Не можем заполнить - должна быть как минимум одна страница, предоставляющая перечень полей и типы данных в них
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РазделОтчета;
	
КонецФункции

#КонецОбласти

