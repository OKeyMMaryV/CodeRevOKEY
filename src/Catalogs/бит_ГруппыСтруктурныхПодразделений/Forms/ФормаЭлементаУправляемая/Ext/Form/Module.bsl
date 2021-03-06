
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	
	
	// Вызов механизма защиты
	  	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Подготовим массив типов для проверки.
	МассивТипов = бит_рлс_Основной.ПодготовитьМассивТиповДляПроверки(Объект);
	
	// Проверка на наличие "битых" ссылок в следствие работы RLS.
	СпрОбъект = ДанныеФормыВЗначение(Объект, Тип("СправочникОбъект.бит_ГруппыСтруктурныхПодразделений"));
	бит_рлс_Основной.ПроверитьБитыеСсылкиВОбъекте(СпрОбъект, МассивТипов, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ЗаполнитьКэшЗначений();
	
	Если Объект.Ссылка = Справочники.бит_ГруппыСтруктурныхПодразделений.НаборВизПоУмолчанию Тогда
	
		Элементы.Состав.Доступность 						   = Ложь;
		Элементы.СоставПодбор.Доступность                  	   = Ложь;
		Элементы.СоставЗаполнитьВсеОрганизации.Доступность     = Ложь;
		Элементы.СоставЗаполнитьВсеЦФО.Доступность		       = Ложь;
		Элементы.СоставЗаполнитьВсеОрганизацииИЦФО.Доступность = Ложь;
		 
	КонецЕсли;
	 
	ЗаполнитьПредставлениеТипаВСоставе();
	 
	фСписокТиповСтруктурноеПодразделение = Новый СписокЗначений;
	РеквизитСтруктурноеПодразделение = Метаданные.Справочники.бит_ГруппыСтруктурныхПодразделений.ТабличныеЧасти.Состав.Реквизиты.СтруктурноеПодразделение;
	фСписокТиповСтруктурноеПодразделение.ЗагрузитьЗначения(РеквизитСтруктурноеПодразделение.Тип.Типы());
	
КонецПроцедуры // ПриСозданииНаСервере()
   
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Организации") 
		ИЛИ ТипЗнч(ВыбранноеЗначение) = Тип(фКэшЗначений.ИмяТипаЦФО) Тогда
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("СтруктурноеПодразделение", ВыбранноеЗначение);
		
		МассивНайденных = Объект.Состав.НайтиСтроки(СтруктураОтбора);
		Если МассивНайденных.Количество() = 0 Тогда
			НоваяСтрока = Объект.Состав.Добавить();
			НоваяСтрока.СтруктурноеПодразделение = ВыбранноеЗначение;
			НоваяСтрока.Тип = ТипЗнч(ВыбранноеЗначение);
		Иначе
			ТекстСообщения = НСтр("ru='Значение ""%1%"" уже подобрано в строке № %2%.'");
			ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ВыбранноеЗначение, МассивНайденных[0].НомерСтроки);
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,Объект.Состав,"СтруктурноеПодразделение");
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры // СоставОбработкаВыбора()

&НаКлиенте
Процедура СоставСтруктурноеПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Состав.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   , Элемент
	                                                   , ТекущиеДанные
	                                                   , "СтруктурноеПодразделение"
													   , фСписокТиповСтруктурноеПодразделение
													   , СтандартнаяОбработка);
													   
КонецПроцедуры // СоставСтруктурноеПодразделениеНачалоВыбора()
                
&НаКлиенте
Процедура СоставСтруктурноеПодразделениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Состав.ТекущиеДанные; 	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Тип = ТипЗнч(ТекущиеДанные.СтруктурноеПодразделение);
	
КонецПроцедуры // СоставСтруктурноеПодразделениеПриИзменении()

&НаКлиенте
Процедура СоставСтруктурноеПодразделениеОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.ВыбиратьТип = Истина;
	
КонецПроцедуры // СоставСтруктурноеПодразделениеОчистка()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьВсеОрганизации(Команда)
	
	ЗадатьВопросНаОчисткуТабЧасти(Новый ОписаниеОповещения("ЗаполнитьВсеОрганизацииОкончание", ЭтотОбъект));
	
КонецПроцедуры // ЗадатьВопросНаОчисткуТабЧасти()

// Процедура окончание процедуры "ЗаполнитьВсеОрганизации".
// 
&НаКлиенте 
Процедура ЗаполнитьВсеОрганизацииОкончание(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Объект.Состав.Очистить(); 
	
	ЗаполнитьСостав("Организации");
	
КонецПроцедуры // ЗаполнитьВсеОрганизацииОкончание()

&НаКлиенте
Процедура ЗаполнитьВсеЦФО(Команда)
	
	ЗадатьВопросНаОчисткуТабЧасти(Новый ОписаниеОповещения("ЗаполнитьВсеЦФООкончание", ЭтотОбъект));
	
КонецПроцедуры // ЗаполнитьВсеЦФО()

// Процедура окончание процедуры "ЗаполнитьВсеЦФО".
// 
&НаКлиенте 
Процедура ЗаполнитьВсеЦФООкончание(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Объект.Состав.Очистить();
	
	ЗаполнитьСостав(бит_ОбщегоНазначения.ПолучитьИмяСправочникаЦФО());
	
КонецПроцедуры // ЗаполнитьВсеЦФООкончание()

&НаКлиенте
Процедура ЗаполнитьВсеОрганизацииИЦФО(Команда)
	
	ЗадатьВопросНаОчисткуТабЧасти(Новый ОписаниеОповещения("ЗаполнитьВсеОрганизацииИЦФООкончание", ЭтотОбъект));
	
КонецПроцедуры // ЗаполнитьВсеОрганизацииИЦФО()

// Процедура окончание процедуры "ЗаполнитьВсеОрганизацииИЦФО".
// 
&НаКлиенте 
Процедура ЗаполнитьВсеОрганизацииИЦФООкончание(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Объект.Состав.Очистить();
	
	ЗаполнитьСостав("Организации");
	ЗаполнитьСостав(бит_ОбщегоНазначения.ПолучитьИмяСправочникаЦФО());
	
КонецПроцедуры // ЗаполнитьВсеОрганизацииИЦФООкончание()

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФорму("Справочник.бит_ГруппыСтруктурныхПодразделений.Форма.ФормаПодбораСтруктурногоПодразделения", ПараметрыФормы, Элементы.Состав);
	
КонецПроцедуры // Подбор()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует кэш значений используемых при работе на клиенте.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()
	
	фКэшЗначений = Новый Структура;
	
	фКэшЗначений.Вставить("ИмяТипаЦФО", бит_ОбщегоНазначения.ПолучитьИмяТипаЦФО());
	
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура заполняет табличную часть состав указанным справочником.
// 
// Параметры:
//  ИмяСправочника  - Строка
// 
&НаСервере
Процедура ЗаполнитьСостав(ИмяСправочника)
	
	Запрос = Новый Запрос;
	Запрос.Текст =  
	"ВЫБРАТЬ
	|	Спр.Ссылка,
	|	ТипЗначения(Спр.Ссылка) КАК Тип
	|ИЗ
	|	Справочник." + ИмяСправочника + " КАК Спр
	|ГДЕ
	|	(НЕ Спр.ПометкаУдаления)";
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Объект.Состав.Добавить();
		НоваяСтрока.СтруктурноеПодразделение = Выборка.Ссылка;
		НоваяСтрока.Тип = Выборка.Тип;
		
	КонецЦикла; 
	
КонецПроцедуры // ЗаполнитьСостав()

&НаСервере
Процедура ЗаполнитьПредставлениеТипаВСоставе()
	
	Для Каждого ТекСтрока Из Объект.Состав Цикл
		
		ТекСтрока.Тип = ТипЗнч(ТекСтрока.СтруктурноеПодразделение);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПредставлениеТипаВСоставе()

&НаКлиенте
Процедура ЗадатьВопросНаОчисткуТабЧасти(Оповещение)
	
	Если Объект.Состав.Количество()>0 Тогда
		
		ТекстВопроса = НСтр("ru='Табличная часть будет очищена. Продолжить?'");
		
		ОповещениеВопрос = Новый ОписаниеОповещения("ОбработкаВопроса", ЭтотОбъект, Оповещение); 
		ПоказатьВопрос(ОповещениеВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 5, КодВозвратаДиалога.Нет);
		
	Иначе
		
		ВыполнитьОбработкуОповещения(Оповещение);
		
	КонецЕсли;
	
КонецПроцедуры // ЗадатьВопросНаОчисткуТабЧасти()

 // Процедура обработка вопроса пользователю.
 // 
 &НаКлиенте 
 Процедура ОбработкаВопроса(Ответ, ДополнительныеДанные) Экспорт
 	
 	Если Ответ = КодВозвратаДиалога.Да Тогда
 		
		ВыполнитьОбработкуОповещения(ДополнительныеДанные);
 		
 	КонецЕсли; 
                 
 КонецПроцедуры // ОбработкаВопроса()
    
#КонецОбласти

