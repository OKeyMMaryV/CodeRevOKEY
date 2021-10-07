﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаГлобальныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если Параметры.Отбор.Свойство("Организация")
		И ЗначениеЗаполнено(Параметры.Отбор.Организация) Тогда
		// Если отбор задан при открытии формы, нужно очистить отбор в параметрах и установить его вручную,
		// иначе будет вызвана ошибка пересечения отборов
		ОсновнаяОрганизация = Параметры.Отбор.Организация;
		Параметры.Отбор.Удалить("Организация");
	Иначе
		ОсновнаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	ОтборОрганизация              = ОсновнаяОрганизация;
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);

	УстановитьВосстановленныеОтборы();
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.ПриходныйКассовыйОрдер)
		И ПравоДоступа("Редактирование", Метаданные.Документы.РасходныйКассовыйОрдер);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	Элементы.СоздатьНаОсновании.Видимость                      = МожноРедактировать;
	Элементы.УплатаНалоговИВзносов.Видимость                   = МожноРедактировать;
	
	ИнтеграцияСБанкамиПодключена = ИнтеграцияСБанкамиПовтИсп.ИнтеграцияВИнформационнойБазеВключена()
		И ОбщегоНазначенияБП.ЭтоИнтерфейсИнтеграцииСБанком();
	БанкИКассаФормы.НастроитьФормуЖурналаДляРежимаИнтеграции(ЭтотОбъект, ИнтеграцияСБанкамиПодключена);
	Элементы.ГруппаОтборКонтрагент.Видимость = Не ИнтеграцияСБанкамиПодключена;
	
	ОбщегоНазначенияБП.УстановитьВидимостьКолонокДополнительнойИнформации(ЭтотОбъект);
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = Новый Массив;
	ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии");
	
	ИмеютсяДействующиеПатенты = УчетПСН.ИмеютсяДействующиеПатенты(ТекущаяДатаСеанса());
	Если ИмеютсяДействующиеПатенты Тогда
		ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии_ИспользуетсяПатент");
	КонецЕсли;
	
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"БП.ЖурналДокументов.Деньги",
		"КассовыеДокументы",
		НСтр("ru = 'Новости: Кассовые документы'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
	УстановитьПрименяетсяУСНПатент();
	
	ИспользуетсяНПД = ПолучитьФункциональнуюОпцию("ДоступнаИнтеграцияСПлатформойСамозанятые");
	
	ТарификацияБП.РазместитьИнформациюОбОграниченииПоКоличествуОбъектов(ЭтотОбъект);
	
	АдресХранилищаНастройкиДинСпискаДляРеестра = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	УстановитьУсловноеОформление();
	
	// бит_Финанс изменения кода. Начало.
	МожноРедактироватьАналитики = ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.бит_ДополнительныеАналитики);
	Если МожноРедактировать И МожноРедактироватьАналитики Тогда
		НоваяКоманда = Команды.Добавить("бит_ДополнительныеАналитики");
		НоваяКоманда.Заголовок = Нстр("ru = 'Аналитики (БИТ)'"); 
		НоваяКоманда.Подсказка = Нстр("ru = 'Дополнительные аналитики'");
		НоваяКоманда.Действие  = "Подключаемый_бит_ДополнительныеАналитики";
		
		Кнопка = Элементы.Добавить("бит_ДополнительныеАналитики", Тип("КнопкаФормы"), Элементы.Список.КонтекстноеМеню);
		Кнопка.ИмяКоманды = НоваяКоманда.Имя;
	КонецЕсли; 
	// бит_Финанс изменения кода. Конец. 

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОсновнаяОрганизация = Параметр;
		Если ОсновнаяОрганизация <> ОтборОрганизация Тогда
			ОтборОрганизация                 = ОсновнаяОрганизация;
			ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
			
			УстановитьВосстановленныеОтборы();
			ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
			ПодключитьОбработчикОжидания("Подключаемый_УстановитьБаннер", 0.1, Истина);
			
		КонецЕсли;
	ИначеЕсли (ИмяСобытия = "ИзмененоСостояниеИнтеграцииСПлатформойСамозанятые"
				ИЛИ ИмяСобытия = "ИзменениеУчетнойПолитики") Тогда
		
		Если ОтборОрганизацияИспользование И ОтборОрганизация = Параметр Тогда
			ПодключитьОбработчикОжидания("Подключаемый_УстановитьБаннер", 0.1, Истина);
		КонецЕсли
		
	ИначеЕсли ИмяСобытия = ЧекиНПДКлиент.ИмяСобытияИзменениеСтатусаОфлайнЧека() Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
	ПрисоединенныеФайлыБПКлиент.ОбновитьСписокПослеДобавленияФайла(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщегоНазначенияБПКлиент.ПроверитьНаличиеОрганизаций();
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьБаннер", 1, Истина);
	
	Если ИспользуетсяНПД Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьСтатусОфлайнЧековНПД", 1, Истина);
	КонецЕсли;
	
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
		Если ОтборОрганизация <> ОсновнаяОрганизация Тогда
			ОтборОрганизация = ОсновнаяОрганизация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		ИначеЕсли НЕ ОтборОрганизацияИспользование Тогда
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВосстановленныеОтборы();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ЗначениеЗаполнено(ОтборДокумент) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыОткрытияДокумента = Неопределено;
		ПараметрыФормы.Вставить("Основание", ОтборДокумент);
		
		Если ПараметрыОткрытияДокумента <> Неопределено Тогда
			ВыбранноеЗначение = ПараметрыОткрытияДокумента.ИмяДокумента;
			ПараметрыФормы    = ПараметрыОткрытияДокумента.ПараметрыФормы;
		КонецЕсли;
		
		ОтборДокумент = Неопределено;
		ОткрытьФорму("Документ." + ВыбранноеЗначение + ".ФормаОбъекта", ПараметрыФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ПерсонализированныеПредложенияСервисовКлиент.ПерейтиПоСсылкеБаннера(
		НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, Баннер, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьБаннер", 0.1, Истина);
	
	ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	
	УстановитьВосстановленныеОтборы();
	
	УстановитьПрименяетсяУСНПатент();
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьБаннер", 0.1, Истина);
	
	ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
	
КонецПроцедуры

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
Процедура НапомнитьПозжеНажатие(Элемент)
	
	ОтложитьПоказНапоминанияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодробнееНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке(СсылкаНаСтатьюИТС);
	
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
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("ПоказатьИнформациюОПравеПримененияСпецрежима", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Не Копирование Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("СписокПередНачаломДобавленияЗавершение", ЭтотОбъект);
		
		СписокСоздаваемыхДокументов = Новый СписокЗначений;
		СписокДоступныхПолей = Список.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора;
		СписокДоступныхТипов = СписокДоступныхПолей.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип.Типы();
		Для каждого ДоступныйТип Из СписокДоступныхТипов Цикл
			СписокСоздаваемыхДокументов.Добавить(ДоступныйТип, Строка(ДоступныйТип));
		КонецЦикла; 
		СписокСоздаваемыхДокументов.СортироватьПоПредставлению();
		
		ПоказатьВыборИзМеню(ОписаниеОповещенияОЗавершении, СписокСоздаваемыхДокументов, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеСтроки.Ссылка) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
		КлючеваяОперация = "ОткрытиеФормыПриходныйКассовыйОрдер";
	ИначеЕсли ТипЗнч(ДанныеСтроки.Ссылка) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
		КлючеваяОперация = "ОткрытиеФормыРасходныйКассовыйОрдер";
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
			ДополнительныеПараметры.Вставить("ПараметрыПеретаскивания", ПараметрыПеретаскивания);
			ДополнительныеПараметры.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
			
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

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	ЧекиНПД.УстановитьВДинамическомСпискеПредставленияАннулированныхЧеков(Строки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПриходныйКассовыйОрдер(Команда)
	
	КлючеваяОперация = "СозданиеФормыПриходныйКассовыйОрдер";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
	СтруктураОтбора = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	ОткрытьФорму("Документ.ПриходныйКассовыйОрдер.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", СтруктураОтбора), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРасходныйКассовыйОрдер(Команда)
	
	КлючеваяОперация = "СозданиеФормыРасходныйКассовыйОрдер";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
	СтруктураОтбора = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	ОткрытьФорму("Документ.РасходныйКассовыйОрдер.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", СтруктураОтбора), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКассовуюКнигу(Команда)
	
	СтруктураПараметров = Новый Структура;
	
	Если ОтборОрганизацияИспользование И ЗначениеЗаполнено(ОтборОрганизация) Тогда
		СтруктураПараметров.Вставить("Организация", ОтборОрганизация);
	КонецЕсли;
	
	ОткрытьФорму("Отчет.КассоваяКнига.Форма", СтруктураПараметров);
	
КонецПроцедуры

&НаКлиенте
Процедура УплатаНалоговИВзносов(Команда)
	
	СтруктураПараметров = Новый Структура;
	
	Если ОтборОрганизацияИспользование И ЗначениеЗаполнено(ОтборОрганизация) Тогда
		СтруктураПараметров.Вставить("Организация", ОтборОрганизация);
	КонецЕсли;
	
	СтруктураПараметров.Вставить("СпособОплаты", ПредопределенноеЗначение("Перечисление.СпособыУплатыНалогов.НаличнымиПоКвитанции"));
	
	ОткрытьФорму("Обработка.ФормированиеПлатежныхПорученийНаУплатуНалогов.Форма", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОсновании(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияИспользования",
		?(ПустаяСтрока(КлючНазначенияИспользования), "КассовыеДокументы", КлючНазначенияИспользования));
	
	Если ТекущиеДанные <> Неопределено Тогда
		ОтборДокумент = ТекущиеДанные.Ссылка;
		ПараметрыФормы.Вставить("Основание", ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	ОткрытьФорму("ЖурналДокументов.Деньги.Форма.ВыборТипаДокумента", ПараметрыФормы, ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтотОбъект,
		Команда
	);
	
КонецПроцедуры

// бит_Финанс изменения кода. Начало.
//
&НаКлиенте
Процедура Подключаемый_бит_ДополнительныеАналитики(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущаяСтрока;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Ссылка", ТекущиеДанные);
		ПараметрыФормы.Вставить("Отбор", Новый Структура("Объект", ТекущиеДанные));
		ПараметрыФормы.Вставить("ТолькоПросмотр", Элементы.Список.ТолькоПросмотр);
		ПараметрыФормы.Вставить("ВызовИзСписка", Истина);
		
		ОткрытьФорму("ОбщаяФорма.бит_РедактированиеДополнительныхАналитик", ПараметрыФормы, 
			Неопределено, ТекущиеДанные,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли; 
	
КонецПроцедуры // бит_Финанс изменения кода. Конец. 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СписокПередНачаломДобавленияЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураОтбора = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	
	Если ВыбранныйЭлемент.Значение = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
		
		ИмяДокумента = "РасходныйКассовыйОрдер";
		
		КлючеваяОперация = "СозданиеФормыРасходныйКассовыйОрдер";
			
	Иначе
		
		ИмяДокумента = "ПриходныйКассовыйОрдер";
		
		КлючеваяОперация = "СозданиеФормыПриходныйКассовыйОрдер";
		
	КонецЕсли;
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
		
	ОткрытьФорму("Документ." + ИмяДокумента + ".ФормаОбъекта",
		Новый Структура("ЗначенияЗаполнения", СтруктураОтбора), ЭтотОбъект);	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// НПД
	БанкИКассаФормы.УстановитьУсловноеОформлениеНПД(ЭтотОбъект);
	
	Если ИнтеграцияСБанкамиПодключена Тогда
		
		// Комментарий
		
		ЭлементУО = УсловноеОформление.Элементы.Добавить();
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Комментарий");
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"ИнтеграцияСБанкамиПодключена", ВидСравненияКомпоновкиДанных.Равно, Истина);
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
		
		// Скрепка
		
		ЭлементУО = УсловноеОформление.Элементы.Добавить();
		КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ЕстьФайлы");
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
			"ИнтеграцияСБанкамиПодключена", ВидСравненияКомпоновкиДанных.Равно, Истина);
		ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
		
	КонецЕсли;
	
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
	
	Если ИмеютсяДействующиеПатенты Тогда
		ИдентификаторыСобытийПриОткрытии.Добавить("ПриОткрытии_ИспользуетсяПатент");
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВосстановленныеОтборы()
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Контрагент");
	
КонецПроцедуры

#Область ПравоПримененияСпецрежима

&НаСервере
Процедура УстановитьПрименяетсяУСНПатент()
	
	ДатаПроверки = ОбщегоНазначения.ТекущаяДатаПользователя();
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ПрименениеУСН        = УчетнаяПолитика.ПрименяетсяУСН(ОтборОрганизация, ДатаПроверки);
		ПрименяетсяУСНПатент = УчетнаяПолитика.ПрименяетсяУСНПатент(ОтборОрганизация, ДатаПроверки);
	Иначе
		ПрименениеУСН        = Ложь;
		ПрименяетсяУСНПатент = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьИнформациюОПравеПримененияСпецрежима()
	
	// Если не заполнена организация, тогда не показываем предупреждение.
	// Если организация не на УСН или Патенте, то не показываем предупреждение.
	Если НЕ (ОтборОрганизацияИспользование И ЗначениеЗаполнено(ОтборОрганизация) 
		И (ПрименениеУСН ИЛИ ПрименяетсяУСНПатент)) Тогда
		Элементы.ИнформацияОПравеПримененияСпецрежима.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	ПоказатьИнформациюОПравеПримененияСпецрежимаНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьИнформациюОПравеПримененияСпецрежимаНаСервере()
	
	ИнформацияОПравеПримененияСпецрежима = КонтрольПраваПримененияСпецрежима.ИнформацияОПравеПримененияСпецрежима(
		ОтборОрганизация, 
		КонтрольПраваПримененияСпецрежима.ИмяПоказателяСпецрежимаДоходы());
	СледующееЗначениеНапоминания         = ИнформацияОПравеПримененияСпецрежима.СледующееЗначениеНапоминания;
	СсылкаНаСтатьюИТС                    = ИнформацияОПравеПримененияСпецрежима.СсылкаНаСтатьюИТС;
	
	Элементы.ИнформацияОПравеПримененияСпецрежима.Видимость = ИнформацияОПравеПримененияСпецрежима.Показать;
	Элементы.ИнформацияОПравеПримененияСпецрежима.ЦветФона = ИнформацияОПравеПримененияСпецрежима.ЦветФонаГруппы;
	Элементы.ТекстИнформации.Заголовок = ИнформацияОПравеПримененияСпецрежима.ТекстИнформации;
	
	Элементы.НапомнитьПозже.Заголовок  = ИнформацияОПравеПримененияСпецрежима.ТекстНапомнитьПозже;
	// В случае если это последний шаг, то прячем команду "Напомнить позже"
	Элементы.НапомнитьПозже.Видимость  = (ИнформацияОПравеПримененияСпецрежима.СледующееЗначениеНапоминания < 100);
	
КонецПроцедуры

&НаСервере
Процедура ОтложитьПоказНапоминанияНаСервере()
	
	КонтрольПраваПримененияСпецрежима.ОтложитьПоказНапоминания(
		ОтборОрганизация, 
		КонтрольПраваПримененияСпецрежима.ИмяПоказателяСпецрежимаДоходы(), 
		СледующееЗначениеНапоминания);
		
	Элементы.ИнформацияОПравеПримененияСпецрежима.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

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
	ОбновитьДоступностьКомандыСоздатьНаОсновании();
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаКлиенте
Процедура ОбновитьДоступностьКомандыСоздатьНаОсновании()
	
	Элементы.СоздатьНаОсновании.Доступность = Элементы.Список.ТекущаяСтрока <> Неопределено;
	
КонецПроцедуры

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
	СтруктураПараметров.Вставить("Размещение", ПерсонализированныеПредложенияСервисов.ИмяРазмещенияКассовыеДокументы());
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

#Область ЧекиНПД

&НаКлиенте
Процедура Подключаемый_ОбновитьСтатусОфлайнЧековНПД()
	
	ЧекиНПДКлиент.ОбновитьСтатусыОфлайнЧековНПД();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
