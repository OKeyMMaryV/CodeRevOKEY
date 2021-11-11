﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания Экспорт;

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОсновнаяОрганизация           = Справочники.Организации.ОрганизацияПоУмолчанию();
	ОтборОрганизация              = ОсновнаяОрганизация;
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	УстановитьВосстановленныеОтборы();
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		Заголовок     = Параметры.Заголовок;
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	ОтборПоВидуОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ПустаяСсылка();
	Если Параметры.Свойство("Отбор") Тогда
		Параметры.Отбор.Свойство("ВидОперации", ОтборПоВидуОперации)
	КонецЕсли;
	
	НесколькоВидовОпераций = НЕ ЗначениеЗаполнено(ОтборПоВидуОперации);
	
	Элементы.ПодменюСоздать.Видимость      = НесколькоВидовОпераций;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Создать", "Видимость", Не НесколькоВидовОпераций);
	Элементы.ИзменитьВидОперации.Видимость = НесколькоВидовОпераций;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.ПоступлениеТоваровУслуг);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	ОбщегоНазначенияБП.УстановитьВидимостьКолонокДополнительнойИнформации(ЭтотОбъект);
	
	// Подсистема "ОбменСКонтрагентами".
	ОбменСКонтрагентамиБП.КомандыЭДО_ФормаСписка(ЭтотОбъект);
	// Конец подсистема "ОбменСКонтрагентами".
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = Новый Массив;
	ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии");
	
	Если Обработки.СверкаДанныхУчетаНДС.ВозможнаСверкаНДС() Тогда
		ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии_СверкаНДС");
	КонецЕсли;
	
	ИспользуетсяЭП = ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольныеЗнакиГИСМ")
		ИЛИ ЭлектронноеВзаимодействиеБП.НастроенОбменЭДО();
	Если ИспользуетсяЭП Тогда
		ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии_ИспользуетсяЭП");
	КонецЕсли;
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"БП.Документ.ПоступлениеТоваровУслуг",
		"ФормаСписка",
		НСтр("ru='Новости: Поступление (акт, накладная)'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
	ТарификацияБП.РазместитьИнформациюОбОграниченииПоКоличествуОбъектов(ЭтотОбъект);
	
	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОсновнаяОрганизация = Параметр;
		Если ОсновнаяОрганизация <> ОтборОрганизация Тогда
			ОтборОрганизация                 = ОсновнаяОрганизация;
			ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
			УстановитьВосстановленныеОтборы();
			УстановитьБаннер();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ЗагруженДокументПоступления" 
		ИЛИ ИмяСобытия = "Запись_СчетФактураПолученный" Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "ИзмененСтатусДокументов" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
	ПрисоединенныеФайлыБПКлиент.ОбновитьСписокПослеДобавленияФайла(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// Подсистема "ОбменСКонтрагентами".
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец подсистема "ОбменСКонтрагентами".
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияБПКлиент.ПроверитьНаличиеОрганизаций() Тогда
		
		// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
		ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
		// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
		
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьБаннер", 1, Истина);
	
	Если ОтображатьСтатусыДокументов Тогда
		
		// Подсистема "ОбменСКонтрагентами"
		ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
		// Конец Подсистема "ОбменСКонтрагентами"
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ПерсонализированныеПредложенияСервисовКлиент.ПерейтиПоСсылкеБаннера(
		НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, Баннер, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СтруктураОтбора = Неопределено;
	Если Параметры.Свойство("Отбор", СтруктураОтбора) И ЗначениеЗаполнено(СтруктураОтбора) Тогда
		
		Если СтруктураОтбора.Свойство("Организация") И ЗначениеЗаполнено(СтруктураОтбора.Организация) Тогда
			ОтборОрганизация = СтруктураОтбора.Организация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
			Параметры.Отбор.Удалить("Организация");
		КонецЕсли;
		Если СтруктураОтбора.Свойство("Контрагент") И ЗначениеЗаполнено(СтруктураОтбора.Контрагент) Тогда
			ОтборКонтрагент = СтруктураОтбора.Контрагент;
			ОтборКонтрагентИспользование = ЗначениеЗаполнено(ОтборКонтрагент);
			Параметры.Отбор.Удалить("Контрагент");
		КонецЕсли;
		
	Иначе
		Если ЗначениеЗаполнено(ОсновнаяОрганизация) И ОтборОрганизация <> ОсновнаяОрганизация Тогда
			ОтборОрганизация = ОсновнаяОрганизация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		ИначеЕсли НЕ ОтборОрганизацияИспользование Тогда
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВосстановленныеОтборы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборКонтрагентИспользованиеПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Контрагент");
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)
	ОтборКонтрагентИспользование = ЗначениеЗаполнено(ОтборКонтрагент);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Контрагент");
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	УстановитьБаннер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьБаннер", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьБаннерНажатие(Элемент)
	
	ОтключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер");
	
	ЗакрытьБаннер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущийБаннерНажатие(Элемент)
	
	ОтключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер");
	
	ПерсонализированныеПредложенияСервисовКлиент.УстановитьРежимОжиданияНаБаннере(ЭтотОбъект);
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьПредыдущийБаннер", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СледующийБаннерНажатие(Элемент)
	
	ОтключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер");
	
	ПерсонализированныеПредложенияСервисовКлиент.УстановитьРежимОжиданияНаБаннере(ЭтотОбъект);
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	Если ТипЗнч(Элемент.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_ПоступлениеТоваровУслуг", , Элемент.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Если ЗначениеЗаполнено(ОтборПоВидуОперации) Тогда
		Если ОтборПоВидуОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Товары") Тогда
			КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугТовары";
		ИначеЕсли ОтборПоВидуОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Услуги") Тогда
			КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугУслуги";
		ИначеЕсли ОтборПоВидуОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Топливо") Тогда
			КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугТопливо";
		Иначе
			КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугОбщая";
		КонецЕсли;
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ДанныеСтроки.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Товары") Тогда
		КлючеваяОперация = "ОткрытиеФормыПоступлениеТоваровУслугТовары";
	ИначеЕсли ДанныеСтроки.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Услуги") Тогда
		КлючеваяОперация = "ОткрытиеФормыПоступлениеТоваровУслугУслуги";
	Иначе
		КлючеваяОперация = "ОткрытиеФормыПоступлениеТоваровУслугОбщая";
	КонецЕсли;

	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);

КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Строка <> Неопределено Тогда
		
		Если ПрисоединенныеФайлыБПКлиент.ПараметрыПеретаскиванияСодержатФайлы(ПараметрыПеретаскивания) Тогда
			
			СтандартнаяОбработка = Ложь;
			
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("Ссылка"                 , Строка);
			ДополнительныеПараметры.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
			ДополнительныеПараметры.Вставить("ПараметрыПеретаскивания", ПараметрыПеретаскивания);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ПеретаскиваниеФайловОтветПолучен",
				ПрисоединенныеФайлыБПКлиент,
				ДополнительныеПараметры);
			ШаблонВопроса = НСтр("ru='Присоединить файлы к документу %1?'");
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонВопроса, Строка);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса,РежимДиалогаВопрос.ДаНет);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФорм

&НаКлиенте
Процедура СоздатьПоступлениеВПереработку(Команда)
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеОборудование(Команда)

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Оборудование"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеОбъектыСтроительства(Команда)

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ОбъектыСтроительства"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеПокупкаКомиссия(Команда)

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ПокупкаКомиссия"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеТовары(Команда)

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Товары"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеУслуги(Команда)

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Услуги"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеУслугиЛизинга(Команда)

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.УслугиЛизинга"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеУслугиАренды(Команда)

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.УслугиАренды"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеУслугиФакторинга(Команда)

	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.УслугиФакторинга"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеОсновныеСредства(Команда)
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ОсновныеСредства"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПриобретениеЗемельныхУчастков(Команда)
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.ПриобретениеЗемельныхУчастков"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоступлениеТоплива(Команда)
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормы(
		ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Топливо"));
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаОбъекта", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидОперации(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ", СтрокаТаблицы.Ссылка);
	ПараметрыФормы.Вставить("ВидОперации", СтрокаТаблицы.ВидОперации);
	ПараметрыФормы.Вставить("ИзменитьВидОперации", Истина);
	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокумента", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОригиналПолучен(Команда)
	
	ОбщегоНазначенияБПКлиент.УстановитьСтатусыВыделенныхДокументов(ЭтотОбъект,
		ПредопределенноеЗначение("Перечисление.СтатусыДокументовПоступления.ОригиналПолучен"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОригиналНеПолучен(Команда)
	
	ОбщегоНазначенияБПКлиент.УстановитьСтатусыВыделенныхДокументов(ЭтотОбъект,
		ПредопределенноеЗначение("Перечисление.СтатусыДокументовПоступления.ОригиналНеПолучен"));
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтатус(Команда)
	
	ОбщегоНазначенияБПКлиент.ИзменитьСтатусыВыделенныхДокументов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВосстановленныеОтборы()
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Контрагент");
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормы(ВидОперации)

	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Товары") Тогда
		КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугТовары";
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Услуги") Тогда
		КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугУслуги";
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеТоваровУслуг.Топливо") Тогда
		КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугТопливо";
	Иначе
		КлючеваяОперация = "СозданиеФормыПоступлениеТоваровУслугОбщая";
	КонецЕсли;
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
	СтруктураПараметров = Новый Структура;
	
	ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	Если ЗначениеЗаполнено(ВидОперации) Тогда
		ЗначенияЗаполнения.Вставить("ВидОперации", ВидОперации);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура НастройкиДинамическогоСписка()
	
	Отчеты.РеестрДокументов.НастройкиДинамическогоСписка(ЭтотОбъект);
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если Команда.Имя = "ПодменюПечатьОбычное_Реестр" Тогда
		НастройкиДинамическогоСписка();
	КонецЕсли;
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область Баннер

&НаКлиенте
Процедура Подключаемый_УстановитьБаннер()
	
	УстановитьБаннер();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьСледующийБаннер()
	
	// Поскольку обработчик может вызываться не только интерактивно пользователем,
	// но и автоматически по таймеру, меняем баннер при условии, что форма находится в фокусе.
	Если НЕ ВводДоступен() Тогда
		ПодключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер",
			ПерсонализированныеПредложенияСервисовКлиент.ИнтервалПереключенияБаннеров(), Истина);
		Возврат;
	КонецЕсли;
	
	УстановитьБаннер();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьПредыдущийБаннер()
	
	УстановитьБаннер(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьБаннер(ПоказатьПредыдущий = Ложь)
	
	ДлительнаяОперация = ПолучитьБаннерНаСервере(ПоказатьПредыдущий);
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус <> "Ошибка" Тогда
		
		НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
		
		Обработчик = Новый ОписаниеОповещения("ПослеПолученияБаннераВФоне", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияБаннераВФоне(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		УстановитьБаннерНаФорме(ДлительнаяОперация.АдресРезультата);
		ПодключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер",
			ПерсонализированныеПредложенияСервисовКлиент.ИнтервалПереключенияБаннеров(), Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьБаннерНаСервере(ПоказатьПредыдущий)
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение баннера в фоне'");
	НастройкиЗапуска.ЗапуститьВФоне = Истина;
	НастройкиЗапуска.ОжидатьЗавершение = 0;
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Организация", ?(ОтборОрганизацияИспользование, ОтборОрганизация, Неопределено));
	СтруктураПараметров.Вставить("Размещение", ПерсонализированныеПредложенияСервисов.ИмяРазмещенияПоступление());
	СтруктураПараметров.Вставить("ПоказатьПредыдущий", ПоказатьПредыдущий);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ПерсонализированныеПредложенияСервисов.ПолучитьБаннер",
		СтруктураПараметров,
		НастройкиЗапуска);
	
КонецФункции

&НаСервере
Процедура УстановитьБаннерНаФорме(АдресРезультата)
	
	ПерсонализированныеПредложенияСервисов.УстановитьБаннерНаФорме(ЭтотОбъект, АдресРезультата);
	
КонецПроцедуры

&НаСервере
Процедура ЗакрытьБаннер()
	
	ПерсонализированныеПредложенияСервисов.ЗакрытьБаннер(ЭтотОбъект, ОтборОрганизация);
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаЭД

&НаКлиенте
Процедура ЗагрузитьРеализациюТоваровИУслугXMLИзЭлектроннойПочты(Команда)
	
	ЭлектронноеВзаимодействиеБПКлиент.ЗагрузитьРеализациюТоваровИУслугИзЭлектроннойПочты(ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРеализациюТоваровИУслугXMLИзФайла(Команда)
	
	ЭлектронноеВзаимодействиеБПКлиент.ЗагрузитьРеализациюТоваровИУслугИзФайла(ЭтотОбъект);
		
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_ОжиданиеКонвертацииФайла()
	
	Попытка
		
		Если ЭлектронноеВзаимодействиеБПВызовСервера.ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			
			ЭлектронноеВзаимодействиеБПКлиент.НачатьЗагрузкуЭД(АдресХранилища, УникальныйИдентификатор);
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);			
			
		Иначе
			
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ОжиданиеКонвертацииФайла", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
				
			КонецЕсли;
			
	Исключение			
		
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтотОбъект,
		Команда
	);

КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = Новый Массив;
	ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии");
	ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии_СверкаНДС");
	Если ИспользуетсяЭП Тогда
		ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии_ИспользуетсяЭП");
	КонецЕсли;

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()

	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзЕГАИС(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьИзЕГАИСЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.ТТНВходящаяЕГАИС.ФормаВыбора",,,,,,ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзЕГАИСЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		ПоступлениеТоваровУслугФормыКлиент.СоздатьПоступлениеПоТТНЕГАИС(РезультатЗакрытия);
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВЕТИС(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьИзВЕТИСЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.ВходящаяТранспортнаяОперацияВЕТИС.ФормаВыбора",,,,,,ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзВЕТИСЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		ПоступлениеТоваровУслугФормыКлиент.СоздатьПоступлениеПоТТНЕГАИС(РезультатЗакрытия);
	КонецЕсли; 

КонецПроцедуры


#КонецОбласти

#КонецОбласти