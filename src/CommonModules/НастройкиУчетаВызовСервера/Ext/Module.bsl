
////////////////////////////////////////////////////////////////////////////////
// Универсальные методы для формы записи регистра и формы настройки налогов
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция КлючЗаписиУчетнойПолитики(ИмяРегистра, Организация, Период) Экспорт
	
	Возврат НастройкиУчета.КлючЗаписиДействующейУчетнойПолитики(ИмяРегистра, Организация, Период);
	
КонецФункции

// Собирает сведения о настройках организации перед их изменением для контроля за необходимостью
// переключения режима отложенного проведения.
//
// Параметры:
//	ИдентификаторФормы - УникальныйИдентификатор - Идентификатор формы.
//	Организация - СправочникСсылка.Организации - Организация, для которой определяются настройки.
//
// Возвращаемое значение:
//	Строка - Адрес временного хранилища, в которое помещены собранные настройки.
//
Функция ПодготовитьДанныеДляПереключенияОтложенногоПроведения(Знач ИдентификаторФормы, Знач Организация) Экспорт

	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОтложенноеПроведение") Тогда
		Возврат "";
	КонецЕсли;

	ПериодыИспользованияОтложенногоПроведения = ПроведениеСервер.ПериодыИспользованияОтложенногоПроведения(Организация);
	
	ДанныеДляПереключения = Новый Структура();
	ДанныеДляПереключения.Вставить("ПериодыИспользованияОтложенногоПроведения", ПериодыИспользованияОтложенногоПроведения);
	ДанныеДляПереключения.Вставить("Организация", Организация);
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеДляПереключения, ИдентификаторФормы);

КонецФункции

// Запускает фоновое задание по переключению режима отложенного проведения при смене настроек.
// Возвращает структуру с данными о фоновом задании см. ДлительныеОперации.ВыполнитьВФоне()
// либо Неопределено, если переключение режима не требуется.
//
// Параметры:
//	ИдентификаторФормы - УникальныйИдентификатор - Идентификатор формы.
//	АдресХранилища - Строка - Адрес временного хранилища, полученный после вызова ПодготовитьДанныеДляПереключенияОтложенногоПроведения().
//
// Возвращаемое значение:
//  Структура - См. возвращаемое значение ДлительныеОперации.ВыполнитьВФоне().
//				Неопределено, если переключение не требуется.
//
Функция ПроверитьОтложенноеПроведениеПослеИзмененияНастроек(Знач ИдентификаторФормы, Знач АдресХранилища) Экспорт

	Если НЕ ЭтоАдресВременногоХранилища(АдресХранилища) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеДляПереключения = ПолучитьИзВременногоХранилища(АдресХранилища);
	 
	Если ЗначениеЗаполнено(ДанныеДляПереключения.Организация) Тогда
		ГоловнаяОрганизация = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(ДанныеДляПереключения.Организация);
	КонецЕсли;

	Результат = ПроведениеСервер.ПроверитьОтложенноеПроведениеПослеИзмененияНастроек(
		ДанныеДляПереключения.ПериодыИспользованияОтложенногоПроведения,
		ИдентификаторФормы,
		ГоловнаяОрганизация);

	Возврат Результат;

КонецФункции

#КонецОбласти